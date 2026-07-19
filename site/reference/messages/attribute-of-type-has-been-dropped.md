---
message: "attribute %d of type %s has been dropped"
slug: attribute-of-type-has-been-dropped
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/executor/execExprInterp.c:2423"
reproduced: false
---

# `attribute %d of type %s has been dropped`

## What it means

A composite value referenced a column that has been dropped from its row type. The placeholders are the attribute number and the type name. Dropped columns leave a tombstone slot, and reading it as a live column is rejected.

## When it happens

It occurs when a stored composite value or a query addresses a column position that `ALTER TABLE ... DROP COLUMN` has since removed, often after the row type changed underneath cached or serialized data.

## How to fix

Reference only live columns of the current row type. If a stale plan or serialized composite is involved, refresh it — reconnect, re-select the value, or rebuild the dependent object — so it reflects the type after the column was dropped.

## Example

*Illustrative* — reading a dropped attribute of a row type.

```text
ERROR:  attribute 3 of type record has been dropped
```

## Related

- [attribute of type has wrong type](./attribute-of-type-has-wrong-type.md)
- [attribute does not exist](./attribute-does-not-exist.md)
