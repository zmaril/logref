---
message: "column is not in index"
slug: column-is-not-in-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/index/genam.c:454"
  - "postgres/src/backend/access/index/genam.c:708"
reproduced: false
---

# `column is not in index`

## What it means

Internal error. Index-access code was asked for a column that the index does not actually contain. It is a consistency check between an index's declared key columns and a request made against it.

## When it happens

It should not occur through ordinary SQL. Reaching it points to an internal inconsistency between an index's catalog definition and the access made against it, not to anything in your query.

## How to fix

Treat it as an internal bug. Capture the query and the index definition and report it. A corrupt index catalog entry could also produce it, so `REINDEX` on the suspect index is worth trying if the same query keeps failing.

## Example

*Illustrative* — emitted internally during index access.

```text
ERROR:  column is not in index
```

## Related

- [could not find junk ctid column](./could-not-find-junk-ctid-column.md)
- [conpfeqop is not a 1-D Oid array](./conpfeqop-is-not-a-1-d-oid-array.md)
