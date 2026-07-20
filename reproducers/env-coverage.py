#!/usr/bin/env python3
"""Join Tier 3-4 env-variant captures against the catalog and report the delta.

Where coverage.py scores a single capture, this scores the *env-variant* pass:
several tagged captures (one per scenario, named `<tier>__<scenario>.json`) plus
an optional Tier 1-2 baseline capture. It reports, honestly:

  * the baseline count (sites the stock-cluster SQL harness already reaches),
  * the NEW distinct sites each env tier adds on top of that baseline,
  * the combined new total out of the whole catalog,

and writes a machine-readable `reproduced-sites.json` of the newly-reached sites
(path:line, severity, message, and which scenario fired them) so a later pass can
flip the matching reference pages' `reproduced` frontmatter with a real example.

Join key is (basename, line) — Postgres trims __FILE__ to a basename — exactly as
coverage.py does.
"""

import argparse
import collections
import glob
import json
import os

from catalog_join import basename, load_catalog


def captured_keys(path):
    """(basename, line) pairs present in one jsonlog file."""
    seen = set()
    if not path or not os.path.exists(path):
        return seen
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            try:
                rec = json.loads(line)
            except json.JSONDecodeError:
                continue
            fname = rec.get("file_name")
            fline = rec.get("file_line_num")
            if fname and fline:
                seen.add((basename(fname), int(fline)))
    return seen


def exact_sites(keys, by_key):
    """Map captured (basename,line) keys -> the set of catalog (path,line) sites."""
    sites = set()
    for key in keys:
        for rec in by_key.get(key, ()):
            sites.add((rec["path"], int(rec["line"])))
    return sites


def rec_for(site, by_key):
    recs = by_key.get((basename(site[0]), site[1]))
    return recs[0] if recs else None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--catalog", required=True)
    ap.add_argument("--caps", required=True, help="dir of <tier>__<scenario>.json")
    ap.add_argument("--baseline", help="Tier 1-2 capture jsonlog")
    ap.add_argument("--out", required=True)
    ap.add_argument("--json-out", required=True)
    ap.add_argument("--commit", default="unknown")
    args = ap.parse_args()

    records, by_key = load_catalog(args.catalog)
    total = len(records)

    baseline_sites = exact_sites(captured_keys(args.baseline), by_key) if args.baseline else set()

    # Per-scenario capture files, grouped by tier.
    scen_sites = {}          # "tier__scenario" -> set of (path,line)
    tier_sites = collections.defaultdict(set)  # "tier3"/"tier4" -> set
    for cap in sorted(glob.glob(os.path.join(args.caps, "*.json"))):
        tag = os.path.basename(cap)[:-5]      # strip .json
        tier = tag.split("__", 1)[0]
        sites = exact_sites(captured_keys(cap), by_key)
        scen_sites[tag] = sites
        tier_sites[tier] |= sites

    env_sites = set().union(*tier_sites.values()) if tier_sites else set()
    new_sites = env_sites - baseline_sites
    combined = baseline_sites | env_sites

    # Attribute each NEW site to the first tier (tier3 before tier4) that fired
    # it, so the per-tier "new" counts sum without double-counting.
    per_tier_new = collections.OrderedDict()
    claimed = set()
    for tier in sorted(tier_sites):
        add = (tier_sites[tier] - baseline_sites) - claimed
        per_tier_new[tier] = add
        claimed |= add

    # Which scenario(s) fired each new site.
    site_scenarios = collections.defaultdict(list)
    for tag, sites in scen_sites.items():
        for s in sites - baseline_sites:
            site_scenarios[s].append(tag)

    # ---- reproduced-sites.json --------------------------------------------
    out_records = []
    for site in sorted(new_sites):
        rec = rec_for(site, by_key)
        if not rec:
            continue
        out_records.append({
            "path": site[0],
            "line": site[1],
            "level": rec.get("level"),
            "sqlstates": rec.get("sqlstates") or [],
            "message": (rec.get("message") or {}).get("text") or "",
            "scenarios": sorted(site_scenarios.get(site, [])),
        })
    with open(args.json_out, "w", encoding="utf-8") as fh:
        json.dump({
            "commit": args.commit,
            "catalog_total": total,
            "baseline_sites": len(baseline_sites),
            "new_sites": len(new_sites),
            "combined_total": len(combined),
            "sites": out_records,
        }, fh, indent=2)
        fh.write("\n")

    # ---- coverage-report.md -----------------------------------------------
    by_level = collections.Counter(
        (rec_for(s, by_key) or {}).get("level") or "?" for s in new_sites)
    by_file = collections.Counter(s[0] for s in new_sites)
    catalog_by_file = collections.Counter(r["path"] for r in records)

    L = []
    a = L.append
    a("# Reproducer coverage report\n")
    a("The Validate stage of LogRef (see `notes/design.md` §4). A HEAD build of")
    a("Postgres is driven through two families of scenarios and its `jsonlog`")
    a("output captured; each line's `file_name:file_line_num` is joined against the")
    a("extracted catalog by `(basename, line)`.\n")
    a("- **Tier 1-2** (`scenarios/`, driver `run.sh`): one stock cluster, crafted")
    a("  SQL — boot/lifecycle LOGs and user-triggerable ERRORs.")
    a("- **Tier 3-4** (`env/`, driver `env-run.sh`): deliberately hostile")
    a("  environments — broken config, rejecting auth, corrupted files, a")
    a("  primary/standby pair, exhausted resources, an un-clean shutdown.\n")
    a(f"- Postgres HEAD commit: `{args.commit}`")
    a(f"- Catalog sites: **{total}**")
    a(f"- Tier 1-2 baseline (exact file:line): **{len(baseline_sites)}** "
      f"({100.0*len(baseline_sites)/total:.2f}%)")
    a(f"- Tier 3-4 adds **{len(new_sites)}** new distinct sites")
    a(f"- **Combined: {len(combined)} of {total} "
      f"({100.0*len(combined)/total:.2f}%)**\n")

    a("## New sites by tier (Tier 3-4)\n")
    a("Attributed to the first tier that fired each site (no double-counting).\n")
    a("| tier | new sites |")
    a("|---|--:|")
    labels = {"tier3": "Tier 3 — config / auth / SSL",
              "tier4": "Tier 4 — corruption / replication / resource / crash"}
    for tier, sites in per_tier_new.items():
        a(f"| {labels.get(tier, tier)} | {len(sites)} |")
    a("")

    a("## New sites by scenario\n")
    a("| scenario | new sites (excl. baseline) |")
    a("|---|--:|")
    for tag in sorted(scen_sites):
        n = len(scen_sites[tag] - baseline_sites)
        a(f"| `{tag}` | {n} |")
    a("")

    a("## New sites by severity\n")
    a("| level | new sites |")
    a("|---|--:|")
    for level, count in by_level.most_common():
        a(f"| {level} | {count} |")
    a("")

    a("## Top source files by new sites\n")
    a("| file | new | in catalog |")
    a("|---|--:|--:|")
    for path, count in by_file.most_common(25):
        a(f"| `{path}` | {count} | {catalog_by_file[path]} |")
    a("")

    a("## Sample new matches (captured jsonlog line -> catalog site)\n")
    shown = 0
    for site in sorted(new_sites):
        rec = rec_for(site, by_key)
        if not rec:
            continue
        msg = (rec.get("message") or {}).get("text") or ""
        msg = msg.replace("|", "\\|")
        if len(msg) > 70:
            msg = msg[:69] + "…"
        sqlstate = ",".join(rec.get("sqlstates") or []) or "-"
        scen = ", ".join(site_scenarios.get(site, [])) or "-"
        a(f"- `{rec['path']}:{rec['line']}` "
          f"[{rec.get('level') or '?'}/{sqlstate}] — {msg}  _(via {scen})_")
        shown += 1
        if shown >= 20:
            break
    a("")

    a("## Methodology and honest limits\n")
    a("Every number above is a site the running database actually printed, joined")
    a("by exact `file:line`. The captures come from a from-source HEAD build driven")
    a("in scratch clusters (Docker daemon unavailable), at `log_min_messages =")
    a("debug5` — the same level as the baseline, so the delta is apples-to-apples.\n")
    a("Timing-sensitive scenarios (streaming/logical replication, crash recovery)")
    a("vary run-to-run by a handful of DEBUG sites; the figures are from one")
    a("representative run. What this environment could **not** reach:\n")
    a("- **OOM / the memory-context dump path** — needs a cgroup memory cap or a")
    a("  real allocator failure; not provokable without container limits here.")
    a("- **amcheck corruption reports** — `contrib/amcheck` is not installed in")
    a("  this build, and its findings return as result rows, not log lines, so they")
    a("  never reach the jsonlog join regardless.")
    a("- **Archiver / `archive_command` failures** and most I/O-error paths in")
    a("  `md.c`/`fd.c` — need a failing archive target or an injected read fault.")
    a("- **Startup-time GUC/`postgresql.conf` fatals** — these print to stderr")
    a("  before the logging collector starts, so they are not in the jsonlog; only")
    a("  the SIGHUP reload path (captured here) logs structurally.\n")

    with open(args.out, "w", encoding="utf-8") as fh:
        fh.write("\n".join(L))

    print(json.dumps({
        "catalog_total": total,
        "baseline_sites": len(baseline_sites),
        "new_sites": len(new_sites),
        "combined_total": len(combined),
        "per_tier_new": {k: len(v) for k, v in per_tier_new.items()},
        "commit": args.commit,
    }))


if __name__ == "__main__":
    main()
