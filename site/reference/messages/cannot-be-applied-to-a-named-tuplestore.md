---
message: "%s cannot be applied to a named tuplestore"
slug: cannot-be-applied-to-a-named-tuplestore
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/analyze.c:3997"
reproduced: false
---

# `%s cannot be applied to a named tuplestore`

## What it means

A locking clause such as `FOR UPDATE` was applied to a named tuplestore — a transition table exposed to a trigger, such as the `OLD TABLE`/`NEW TABLE` relations. Those are in-memory result sets, not lockable base tables.

## When it happens

It occurs when a query inside a trigger or similar context applies a row-locking clause to a transition-table relation.

## How to fix

Remove the locking clause from the tuplestore reference. If you need to lock actual rows, run a separate query against the underlying table instead of the transition table.

## Example

*Illustrative* — locking a transition table.

```text
ERROR:  FOR UPDATE cannot be applied to a named tuplestore
```

## Related

- [cannot be applied to a with query](./cannot-be-applied-to-a-with-query.md)
- [cannot be applied to a table function](./cannot-be-applied-to-a-table-function.md)
