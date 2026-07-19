---
message: "cannot change materialized view \"%s\""
slug: cannot-change-materialized-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1124"
reproduced: false
---

# `cannot change materialized view "%s"`

## What it means

A data-modifying statement such as `INSERT`, `UPDATE`, or `DELETE` targeted a materialized view. Materialized views are refreshed as a whole from their defining query and cannot be modified row by row. The placeholder is the view name.

## When it happens

It occurs when a write statement names a materialized view as its target relation.

## How to fix

Refresh the materialized view with `REFRESH MATERIALIZED VIEW` to update its contents, or write to the underlying base tables. Materialized views are read-only between refreshes.

## Example

*Illustrative* — writing to a materialized view.

```text
ERROR:  cannot change materialized view "mv"
```

## Related

- [cannot change sequence](./cannot-change-sequence.md)
- [cannot change relation](./cannot-change-relation.md)
