#!/usr/bin/env python3
"""Join captured Postgres jsonlog output against the LogRef catalog.

The Validate stage produces a coverage number: of the N call sites in the
static catalog, how many did we actually make the running database emit?

Ground truth is Postgres's own `jsonlog` output. With `log_error_verbosity =
verbose` every record carries `file_name` + `file_line_num` — the __FILE__ and
__LINE__ of the ereport/elog call site. Postgres trims __FILE__ to a basename,
so we join on (basename, line) against the catalog's `path`/`line`.

Usage:
    coverage.py --catalog <catalog.jsonl> --logs <jsonlog...> \
                --out <report.md> [--window N]

`--window` (default 0) also reports a looser count where a captured line is
accepted if it falls within [catalog.line, catalog.end_line] (or within N lines
of catalog.line when no end_line is recorded). The headline number is always the
exact (basename, line) match; the window is a diagnostic for macro/__LINE__ skew.
"""

import argparse
import collections
import json
import os
import sys

from catalog_join import basename, load_catalog


def load_captures(paths):
    """Return a set of (basename, line) seen in the jsonlog files."""
    seen = set()
    malformed = 0
    for path in paths:
        if not os.path.exists(path):
            continue
        with open(path, encoding="utf-8") as fh:
            for line in fh:
                line = line.strip()
                if not line:
                    continue
                try:
                    rec = json.loads(line)
                except json.JSONDecodeError:
                    malformed += 1
                    continue
                fname = rec.get("file_name")
                fline = rec.get("file_line_num")
                if fname and fline:
                    seen.add((basename(fname), int(fline)))
    return seen, malformed


def windowed_hits(captured, catalog_records, window):
    """Catalog records whose [line, end_line] span contains a captured line."""
    by_base = collections.defaultdict(list)
    for base, line in captured:
        by_base[base].append(line)
    hits = set()
    for rec in catalog_records:
        base = basename(rec["path"])
        lo = int(rec["line"])
        hi = int(rec.get("end_line", lo))
        lo -= window
        hi += window
        for line in by_base.get(base, ()):
            if lo <= line <= hi:
                hits.add((rec["path"], int(rec["line"])))
                break
    return hits


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--catalog", required=True)
    ap.add_argument("--logs", nargs="+", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--window", type=int, default=3)
    ap.add_argument("--commit", default="unknown", help="Postgres HEAD commit sha")
    args = ap.parse_args()

    records, by_key = load_catalog(args.catalog)
    captured, malformed = load_captures(args.logs)

    # Exact (basename, line) match -> the set of distinct catalog sites hit.
    matched_sites = set()
    matched_records = []
    unmatched_captures = set()
    for key in captured:
        recs = by_key.get(key)
        if recs:
            for rec in recs:
                loc = (rec["path"], int(rec["line"]))
                if loc not in matched_sites:
                    matched_sites.add(loc)
                    matched_records.append(rec)
        else:
            unmatched_captures.add(key)

    total = len(records)
    n_hit = len(matched_sites)
    win_hit = windowed_hits(captured, records, args.window)

    by_level = collections.Counter()
    by_file = collections.Counter()
    for rec in matched_records:
        by_level[rec.get("level") or "?"] += 1
        by_file[rec["path"]] += 1

    catalog_by_file = collections.Counter(r["path"] for r in records)

    lines = []
    add = lines.append
    add("# Reproducer coverage report\n")
    add("The Validate stage of LogRef (see `notes/design.md` §4): a HEAD build of")
    add("Postgres was driven through the scenarios in `reproducers/scenarios/`, its")
    add("`jsonlog` output captured, and each line's `file_name:file_line_num` joined")
    add("against the extracted catalog by `(basename, line)`.\n")
    add(f"- Postgres HEAD commit: `{args.commit}`")
    add(f"- Catalog sites: **{total}**")
    add(f"- Distinct sites reproduced (exact file:line): **{n_hit}** "
        f"({100.0 * n_hit / total:.2f}%)")
    add(f"- Distinct sites reproduced (±{args.window}-line window): "
        f"**{len(win_hit)}** ({100.0 * len(win_hit) / total:.2f}%)")
    add(f"- Distinct captured call sites with no catalog match: "
        f"{len(unmatched_captures)}")
    if malformed:
        add(f"- Malformed jsonlog lines skipped: {malformed}")
    add("")

    add("## Reproduced sites by severity\n")
    add("| level | sites hit |")
    add("|---|--:|")
    for level, count in by_level.most_common():
        add(f"| {level} | {count} |")
    add("")

    add("## Top source files by sites reproduced\n")
    add("| file | hit | in catalog |")
    add("|---|--:|--:|")
    for path, count in by_file.most_common(25):
        add(f"| `{path}` | {count} | {catalog_by_file[path]} |")
    add("")

    add("## Sample matches (captured jsonlog line -> catalog site)\n")
    for rec in matched_records[:12]:
        msg = (rec.get("message") or {}).get("text") or ""
        msg = msg.replace("|", "\\|")
        if len(msg) > 70:
            msg = msg[:67] + "..."
        sqlstate = ",".join(rec.get("sqlstates") or []) or "-"
        add(f"- `{rec['path']}:{rec['line']}` "
            f"[{rec.get('level') or '?'}/{sqlstate}] — {msg}")
    add("")

    report = "\n".join(lines)
    with open(args.out, "w", encoding="utf-8") as fh:
        fh.write(report)

    # Machine-readable summary to stdout for the driver.
    print(json.dumps({
        "catalog_total": total,
        "exact_hits": n_hit,
        "window_hits": len(win_hit),
        "window": args.window,
        "unmatched_captures": len(unmatched_captures),
        "commit": args.commit,
    }))
    return 0


if __name__ == "__main__":
    sys.exit(main())
