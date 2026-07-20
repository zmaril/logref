---
message: "index \"%s\" is not valid"
slug: index-is-not-valid
passthrough: false
api: [ereport]
level: [DEBUG1, ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/contrib/pgstattuple/pgstatindex.c:248"
  - "postgres/contrib/pgstattuple/pgstatindex.c:562"
  - "postgres/contrib/pgstattuple/pgstatindex.c:652"
  - "postgres/contrib/pgstattuple/pgstattuple.c:266"
  - "postgres/src/backend/access/brin/brin.c:1475"
  - "postgres/src/backend/access/brin/brin.c:1571"
  - "postgres/src/backend/access/gin/ginfast.c:1083"
  - "postgres/src/backend/parser/parse_utilcmd.c:2458"
reproduced: false
---

# `index "%s" is not valid`

## What it means

An index exists but is marked invalid, so it cannot be used. The placeholder is the index name. An index becomes invalid when a `CREATE INDEX CONCURRENTLY` or `REINDEX CONCURRENTLY` failed partway, leaving the index present in the catalog but not usable for queries or constraints.

## When it happens

After a concurrent index build was interrupted (crash, cancellation, deadlock) and did not complete. The `DEBUG1` occurrences are the planner noting it will not use the invalid index; the `ERROR` occurs where a valid index is required (for example attaching it to a constraint).

## How to fix

Drop the invalid index and rebuild it: `DROP INDEX name;` then `CREATE INDEX CONCURRENTLY ...` again, or `REINDEX INDEX CONCURRENTLY name` on modern versions. Find invalid indexes with `SELECT indexrelid::regclass FROM pg_index WHERE NOT indisvalid`. Investigate why the concurrent build failed (deadlock, cancellation) before retrying.

## Example

*Illustrative* — a query planner skipping an invalid index.

```text
ERROR:  index "idx_orders_cust" is not valid
```

## Related

- [index already contains data](./index-already-contains-data.md)
- [cache lookup failed for index](./cache-lookup-failed-for-index.md)
