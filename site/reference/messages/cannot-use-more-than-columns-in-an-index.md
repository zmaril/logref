---
message: "cannot use more than %d columns in an index"
slug: cannot-use-more-than-columns-in-an-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TOO_MANY_COLUMNS
    code: "54011"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:675"
reproduced: false
---

# `cannot use more than %d columns in an index`

## What it means

An index definition listed more key columns than the server's fixed maximum, which is 32 by default. An index cannot exceed that column count, so the definition is rejected.

## When it happens

It occurs on `CREATE INDEX` or a constraint that builds an index when the column list is longer than the compiled limit.

## How to fix

Reduce the number of indexed columns to the limit or fewer. Combine columns into an expression, or split the requirement across more than one index if you need broader coverage.

## Example

*Illustrative* — too many index columns.

```text
ERROR:  cannot use more than 32 columns in an index
```

## Related

- [cannot use an existing index in CREATE TABLE](./cannot-use-an-existing-index-in-create-table.md)
- [cannot use non-unique index as replica identity](./cannot-use-non-unique-index-as-replica-identity.md)
