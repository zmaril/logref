---
message: "cannot have more than %d columns in statistics"
slug: cannot-have-more-than-columns-in-statistics
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TOO_MANY_COLUMNS
    code: "54011"
call_sites:
  - "postgres/src/backend/commands/statscmds.c:241"
reproduced: false
---

# `cannot have more than %d columns in statistics`

## What it means

A `CREATE STATISTICS` object listed more columns than an extended-statistics object may cover. Postgres caps the number of columns per statistics object, and the request exceeded it. The placeholder is the maximum column count.

## When it happens

It occurs when `CREATE STATISTICS` names more columns than the limit (the same cap as the maximum columns in an index).

## How to fix

Reduce the column list to the limit, or create several statistics objects that each cover a subset of the columns. Focus each object on the correlated columns whose combined distribution you need.

## Example

*Illustrative* — too many columns in one statistics object.

```text
ERROR:  cannot have more than 32 columns in statistics
```

## Related

- [cannot have more than keys in a foreign key](./cannot-have-more-than-keys-in-a-foreign-key.md)
- [cannot modify statistics for relation](./cannot-modify-statistics-for-relation.md)
