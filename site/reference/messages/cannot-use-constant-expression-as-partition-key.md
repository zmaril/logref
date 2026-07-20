---
message: "cannot use constant expression as partition key"
slug: cannot-use-constant-expression-as-partition-key
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:20705"
reproduced: false
---

# `cannot use constant expression as partition key`

## What it means

A partition key was defined as an expression that reduces to a constant. A partition key must depend on the row's column values to distribute rows, so a constant expression, which is the same for every row, is not a valid key.

## When it happens

It occurs on `CREATE TABLE ... PARTITION BY RANGE|LIST|HASH ((constant expression))`.

## How to fix

Use an expression that references one or more table columns, or a plain column, as the partition key. Remove the constant and base the key on real column data.

## Example

*Illustrative* — a constant partition key.

```sql
CREATE TABLE t (a int) PARTITION BY RANGE ((1));
-- ERROR:  cannot use constant expression as partition key
```

## Related

- [cannot use system column in partition key](./cannot-use-system-column-in-partition-key.md)
- [cannot use "list" partition strategy with more than one column](./cannot-use-list-partition-strategy-with-more-than-one-column.md)
