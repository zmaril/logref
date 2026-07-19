---
message: "%s cannot be applied to a table function"
slug: cannot-be-applied-to-a-table-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/analyze.c:3970"
reproduced: false
---

# `%s cannot be applied to a table function`

## What it means

A locking clause such as `FOR UPDATE` was applied to a table function — an `XMLTABLE` or `JSON_TABLE` construct in `FROM`. These produce computed rows, not stored rows, so they cannot be locked.

## When it happens

It occurs when a `SELECT ... FOR UPDATE`/`FOR SHARE` lists a table-function item among its locked relations.

## How to fix

Remove the table function from the locking clause and lock only real tables. If the generated rows must be locked, insert them into a table first, then lock that table.

## Example

*Illustrative* — locking a table function.

```text
ERROR:  FOR UPDATE cannot be applied to a table function
```

## Related

- [cannot be applied to a function](./cannot-be-applied-to-a-function.md)
- [cannot be applied to a named tuplestore](./cannot-be-applied-to-a-named-tuplestore.md)
