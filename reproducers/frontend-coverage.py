#!/usr/bin/env python3
"""
Frontend client-tool log-site matcher for the LogRef reproducer harness.

Frontend tools (pg_dump, pgbench, clusterdb, ...) print pg_log_error/pg_fatal
output as plain text to stderr -- "progname: error: <message>" -- with NO
source file/line.  The jsonlog file:line join used for backend sites therefore
cannot reach them.  Instead we RUN each tool into a real error (frontend-run.sh),
capture its stderr, and attribute each captured line to the UNIQUE frontend
catalog site whose printf format string matches it, constrained to that tool's
own source file(s) plus the shared fe_utils / common helpers.

Strict uniqueness keeps it honest: a captured line is only credited when exactly
one candidate site matches.  Zero or >1 matches are recorded as unmatched /
ambiguous and NOT counted.

Inputs mirror env-coverage.py: the catalog path comes from the CATALOG env var,
everything else is an argument.

  CATALOG (env)    catalog JSONL (frontend sites are the `kind == "frontend"` rows)
  --caps           the runner's capture file ($CAPS/frontend.txt)
  --json-out       machine-readable {summary, new_sites} JSON (the dry-run delta)
  --out            human-readable Markdown report
  --reproduced     existing reproduced-sites.json, for the genuinely-new delta
                   (default: reproduced-sites.json beside this script)
"""
import argparse
import json
import os
import re
from collections import defaultdict

from catalog_join import load_catalog

CATALOG = os.environ.get("CATALOG")
_HERE = os.path.dirname(os.path.abspath(__file__))

# tool basename -> its own primary source file(s). "prefix:" means any file
# under that directory. fe_utils/* and common/* are ALWAYS added as shared
# candidates (option-validation helpers reused across tools).
TOOL_FILES = {
    "pg_dump": ["src/bin/pg_dump/pg_dump.c"],
    "pg_dumpall": ["src/bin/pg_dump/pg_dumpall.c"],
    "pg_restore": ["src/bin/pg_dump/pg_restore.c"],
    "pg_basebackup": ["src/bin/pg_basebackup/pg_basebackup.c"],
    "pg_receivewal": ["src/bin/pg_basebackup/pg_receivewal.c"],
    "pg_recvlogical": ["src/bin/pg_basebackup/pg_recvlogical.c"],
    "pg_rewind": ["src/bin/pg_rewind/pg_rewind.c"],
    "pg_combinebackup": ["src/bin/pg_combinebackup/pg_combinebackup.c"],
    "pg_verifybackup": ["src/bin/pg_verifybackup/pg_verifybackup.c"],
    "pg_waldump": ["src/bin/pg_waldump/pg_waldump.c"],
    "pg_checksums": ["src/bin/pg_checksums/pg_checksums.c"],
    "pg_amcheck": ["src/bin/pg_amcheck/pg_amcheck.c"],
    "pgbench": ["src/bin/pgbench/pgbench.c"],
    "psql": ["prefix:src/bin/psql/"],
    "initdb": ["src/bin/initdb/initdb.c"],
    "pg_ctl": ["src/bin/pg_ctl/pg_ctl.c"],
    "reindexdb": ["src/bin/scripts/reindexdb.c"],
    "vacuumdb": ["src/bin/scripts/vacuumdb.c"],
    "clusterdb": ["src/bin/scripts/clusterdb.c"],
    "createdb": ["src/bin/scripts/createdb.c"],
    "dropdb": ["src/bin/scripts/dropdb.c"],
    "createuser": ["src/bin/scripts/createuser.c"],
    "dropuser": ["src/bin/scripts/dropuser.c"],
    "pg_upgrade": ["prefix:src/bin/pg_upgrade/"],
}

# which scenario group (66-69) owns each tool, for the breakdown.
SCENARIO_OF = {}
for t in ("pg_dump", "pg_restore", "pg_dumpall", "pg_upgrade"):
    SCENARIO_OF[t] = 66
for t in (
    "pg_basebackup", "pg_receivewal", "pg_recvlogical", "pg_rewind",
    "pg_combinebackup", "pg_verifybackup", "pg_waldump", "pg_checksums",
    "pg_amcheck",
):
    SCENARIO_OF[t] = 67
for t in ("pgbench", "psql"):
    SCENARIO_OF[t] = 68
for t in (
    "initdb", "pg_ctl", "reindexdb", "vacuumdb", "clusterdb",
    "createdb", "dropdb", "createuser", "dropuser",
):
    SCENARIO_OF[t] = 69


def norm(path):
    """Strip the leading 'postgres/' repo prefix used in the catalog."""
    return path[len("postgres/"):] if path.startswith("postgres/") else path


# ---- printf format string -> anchored regex -------------------------------
# One conversion spec: %%  OR  % [flags][width][.prec][length] <conv-char>
_CONV = re.compile(
    r"%(?:%|[-+ #0]*[0-9*]*(?:\.[0-9*]+)?(?:hh|h|ll|l|L|z|t|j|q)?[diouxXeEfFgGaAcspm])"
)


def literal_alnum(text):
    """Alphanumeric chars left after removing every conversion spec.

    A site whose format string is pure passthrough -- pg_fatal("%s", err),
    "%s: %s", "%m" -- has no literal content and can NEVER be distinctively
    identified from stderr text (any output could have come from it).  Such
    sites are excluded from candidacy: keeping them only poisons every line
    into ambiguity.  Excluding them does not loosen the uniqueness rule -- it
    removes sites that are unidentifiable-by-message, which is exactly what an
    honest message-based attribution must do.
    """
    skel = _CONV.sub("", text)
    return sum(c.isalnum() for c in skel)


def is_distinctive(text):
    return literal_alnum(text) >= 3


def fmt_to_regex(text):
    """Convert a C printf format string to an anchored (fullmatch) regex."""
    out = []
    pos = 0
    for m in _CONV.finditer(text):
        out.append(re.escape(text[pos:m.start()]))
        tok = m.group(0)
        if tok == "%%":
            out.append(re.escape("%"))
        else:
            conv = tok[-1]
            if conv == "c":
                out.append(".")
            else:  # s, m, d, u, x, ... -> arbitrary run (incl. empty)
                out.append(".*")
        pos = m.end()
    out.append(re.escape(text[pos:]))
    return re.compile("".join(out), re.DOTALL)


# strip "progname: error|warning|detail|hint: " -- progname may be a full path.
_PREFIX = re.compile(r"^.*?: (?:error|warning|detail|hint): ?")


def load_sites(records):
    """Frontend catalog sites (kind=="frontend") with a message-match regex.

    `records` is the full catalog as loaded by catalog_join.load_catalog.
    """
    sites = []  # list of dict: path(norm), line, api, level, text, regex
    nondistinct = 0
    for r in records:
        if r.get("kind") != "frontend":
            continue
        m = r.get("message") or {}
        t = m.get("text")
        if not t:
            continue
        if not is_distinctive(t):
            nondistinct += 1
            continue  # pure passthrough -- unidentifiable by message
        p = norm(r["path"])
        sites.append({
            "path": p, "line": r["line"], "api": r["api"],
            "level": r["level"], "text": t, "regex": fmt_to_regex(t),
        })
    return sites, nondistinct


def candidates_for(tool, sites):
    specs = TOOL_FILES.get(tool, [])
    files_exact = set()
    prefixes = []
    for s in specs:
        if s.startswith("prefix:"):
            prefixes.append(s[len("prefix:"):])
        else:
            files_exact.add(s)
    out = []
    for st in sites:
        p = st["path"]
        if p in files_exact or any(p.startswith(pre) for pre in prefixes):
            out.append(st)
        elif p.startswith("src/fe_utils/") or p.startswith("src/common/"):
            out.append(st)
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--caps", required=True,
                    help="capture file written by frontend-run.sh ($CAPS/frontend.txt)")
    ap.add_argument("--json-out", required=True,
                    help="machine-readable {summary, new_sites} JSON")
    ap.add_argument("--out", help="human-readable Markdown report")
    ap.add_argument("--reproduced",
                    default=os.path.join(_HERE, "reproduced-sites.json"),
                    help="existing reproduced-sites.json (for the genuinely-new delta)")
    args = ap.parse_args()

    if not CATALOG:
        ap.error("set the CATALOG env var to the catalog JSONL path")

    capfile = args.caps
    records, _by_key = load_catalog(CATALOG)
    sites, nondistinct = load_sites(records)
    cand_cache = {}

    existing = set()
    if os.path.exists(args.reproduced):
        rj = json.load(open(args.reproduced))
        for s in rj.get("sites", []):
            existing.add((norm(s["path"]), s["line"]))

    # parse the capture file into (tool, [error lines])
    total_error_lines = 0
    unique_matched = 0      # captured lines credited to a unique site
    ambiguous = 0
    unmatched = 0
    matched_site = {}       # (path,line) -> site dict
    site_examples = defaultdict(list)  # (path,line) -> [(tool, capline)]
    ambiguous_examples = []
    unmatched_examples = []
    per_tool_lines = defaultdict(int)

    cur_tool = None
    cur_argv = ""
    with open(capfile) as f:
        for raw in f:
            line = raw.rstrip("\n")
            if line.startswith("### tool="):
                body = line[len("### tool="):]
                if " argv=" in body:
                    cur_tool, cur_argv = body.split(" argv=", 1)
                    cur_tool = cur_tool.strip()
                    cur_argv = cur_argv.strip()
                else:
                    cur_tool = body.strip()
                    cur_argv = cur_tool
                continue
            if not line.strip():
                continue
            if cur_tool is None:
                continue
            # only lines that look like a pg_log emission (progname: level:)
            if not re.match(r"^.*?: (?:error|warning|detail|hint|fatal): ", line):
                continue
            total_error_lines += 1
            per_tool_lines[cur_tool] += 1

            if cur_tool not in cand_cache:
                cand_cache[cur_tool] = candidates_for(cur_tool, sites)
            cands = cand_cache[cur_tool]

            stripped = _PREFIX.sub("", line, count=1)
            variants = {stripped, line}

            hits = {}  # (path,line) -> site
            for st in cands:
                rgx = st["regex"]
                if any(rgx.fullmatch(v) for v in variants):
                    hits[(st["path"], st["line"])] = st

            if len(hits) == 1:
                unique_matched += 1
                (key,), = (list(hits.keys()),)
                st = hits[key]
                matched_site[key] = st
                if len(site_examples[key]) < 3:
                    site_examples[key].append((cur_tool, cur_argv, line))
            elif len(hits) == 0:
                unmatched += 1
                if len(unmatched_examples) < 60:
                    unmatched_examples.append((cur_tool, line))
            else:
                ambiguous += 1
                if len(ambiguous_examples) < 60:
                    ambiguous_examples.append(
                        (cur_tool, line, sorted(f"{k[0]}:{k[1]}" for k in hits))
                    )

    # genuinely-new = matched sites not already in reproduced-sites.json
    new_sites = []
    for key, st in sorted(matched_site.items()):
        if key in existing:
            continue
        ex = site_examples[key]
        tool = ex[0][0] if ex else ""
        argv = ex[0][1] if ex else ""
        cap = ex[0][2] if ex else ""
        new_sites.append({
            "path": "postgres/" + st["path"],
            "line": st["line"],
            "level": st["level"],
            "api": st["api"],
            "message": st["text"],
            "tool": tool,
            "trigger_cmd": argv,
            "captured_stderr": cap,
        })

    summary = {
        "total_captured_error_lines": total_error_lines,
        "unique_matched_lines": unique_matched,
        "distinct_matched_sites": len(matched_site),
        "ambiguous_lines": ambiguous,
        "unmatched_lines": unmatched,
        "already_reproduced_of_matched": len(matched_site) - len(new_sites),
        "genuinely_new": len(new_sites),
        "nondistinctive_sites_excluded": nondistinct,
    }

    # per-scenario / per-tool breakdown of GENUINELY-NEW sites
    new_by_tool = defaultdict(int)
    new_by_scen = defaultdict(int)
    for ns in new_sites:
        new_by_tool[ns["tool"]] += 1
        new_by_scen[SCENARIO_OF.get(ns["tool"], 0)] += 1

    with open(args.json_out, "w") as f:
        json.dump({
            "summary": summary,
            "per_scenario": {str(s): new_by_scen.get(s, 0) for s in (66, 67, 68, 69)},
            "per_tool": dict(sorted(new_by_tool.items(), key=lambda kv: -kv[1])),
            "new_sites": new_sites,
        }, f, indent=2)

    # ---- human-readable Markdown report ----------------------------------
    if args.out:
        scen_label = {66: "66 — dump/restore/dumpall/upgrade",
                      67: "67 — physical/backup tools",
                      68: "68 — pgbench + psql",
                      69: "69 — scripts + initdb + pg_ctl"}
        L = []
        a = L.append
        a("# Frontend client-tool coverage (dry run)\n")
        a("Frontend tools call `pg_log_error`/`pg_fatal`, which print plain stderr")
        a("with NO source location, so the jsonlog file:line join cannot reach them.")
        a("Each captured `progname: level: <message>` line is attributed to the UNIQUE")
        a("frontend catalog site whose printf format matches it, scoped to the tool's")
        a("own source file(s) ∪ `fe_utils` ∪ `common`.\n")
        for k, v in summary.items():
            a(f"- {k.replace('_', ' ')}: **{v}**")
        a("")
        a("## Genuinely-new sites per scenario group\n")
        a("| scenario group | new sites |")
        a("|---|--:|")
        for scen in (66, 67, 68, 69):
            a(f"| {scen_label[scen]} | {new_by_scen.get(scen, 0)} |")
        a("")
        a("## Genuinely-new sites per tool\n")
        a("| tool | new sites |")
        a("|---|--:|")
        for t in sorted(new_by_tool, key=lambda x: -new_by_tool[x]):
            a(f"| `{t}` | {new_by_tool[t]} |")
        a("")
        a("## Sample new matches (captured stderr -> catalog site)\n")
        for ns in new_sites[:20]:
            msg = ns["message"].replace("|", "\\|")
            if len(msg) > 60:
                msg = msg[:59] + "…"
            a(f"- `{ns['path']}:{ns['line']}` [{ns['level']}] — {msg}  "
              f"_(via `{ns['tool']}`)_")
        a("")
        with open(args.out, "w") as f:
            f.write("\n".join(L))

    # ---- stdout one-line summary (mirrors env-coverage.py) ---------------
    print(json.dumps({
        "distinct_matched_sites": summary["distinct_matched_sites"],
        "genuinely_new": summary["genuinely_new"],
        "per_scenario": {str(s): new_by_scen.get(s, 0) for s in (66, 67, 68, 69)},
        "ambiguous_lines": ambiguous,
        "unmatched_lines": unmatched,
    }))


if __name__ == "__main__":
    main()
