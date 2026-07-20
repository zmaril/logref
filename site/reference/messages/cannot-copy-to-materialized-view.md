---
message: "cannot copy to materialized view \"%s\""
slug: cannot-copy-to-materialized-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/copyfrom.c:829"
reproduced: false
---

# `cannot copy to materialized view "%s"`

## What it means

A `COPY ... FROM` named a materialized view as its target. Materialized views are populated by refreshing their defining query, not by loading rows, so `COPY FROM` cannot write to them. The placeholder is the view name.

## When it happens

It occurs when `COPY matview FROM ...` names a materialized view.

## How to fix

Load data into the base tables the materialized view reads, then `REFRESH MATERIALIZED VIEW`. A materialized view's contents come from its query, not from direct loads.

## Example

*Illustrative* — COPY into a matview.

```text
ERROR:  cannot copy to materialized view "mv"
```

## Related

- [cannot copy from unpopulated materialized view](./cannot-copy-from-unpopulated-materialized-view.md)
- [cannot copy to view](./cannot-copy-to-view.md)
