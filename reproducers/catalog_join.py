"""Shared catalog-join helpers for the reproducer coverage tools.

Both coverage.py (Tiers 1-2) and env-coverage.py (Tiers 3-4) load the catalog
and match captured jsonlog locations against it on the same key: Postgres trims
__FILE__ to a basename, so a captured `int.c:942` joins the catalog's
`.../utils/adt/int.c:942`. Keeping that logic in one place avoids two subtly
different copies of the join.
"""

import collections
import json


def basename(path):
    return path.rsplit("/", 1)[-1]


def load_catalog(path):
    """Return (records, by_key) where by_key maps (basename, line) -> [record]."""
    records = []
    by_key = collections.defaultdict(list)
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            rec = json.loads(line)
            if "path" not in rec or "line" not in rec:
                continue
            records.append(rec)
            by_key[(basename(rec["path"]), int(rec["line"]))].append(rec)
    return records, by_key
