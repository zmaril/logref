---
message: "cannot use \"list\" partition strategy with more than one column"
slug: cannot-use-list-partition-strategy-with-more-than-one-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:20475"
reproduced: true
---

# `cannot use "list" partition strategy with more than one column`

## What it means

A `PARTITION BY LIST` clause named more than one column. List partitioning matches a single key value against each partition's value list, so it accepts only one column or expression.

## When it happens

It occurs on `CREATE TABLE ... PARTITION BY LIST (a, b)` with two or more partition columns.

## How to fix

Use a single column or expression for list partitioning. If you need to partition on several columns together, use range or hash partitioning, which accept multiple columns.

## Example

*Reproduced* — captured from `reproducers/scenarios/31_createtable_view_trigger.sql`.

```sql
CREATE TABLE repro.ct17 (a int) PARTITION BY LIST (a, b);
```

Produces:

```text
ERROR:  cannot use "list" partition strategy with more than one column
```

## Related

- [cannot use constant expression as partition key](./cannot-use-constant-expression-as-partition-key.md)
- [cannot use system column in partition key](./cannot-use-system-column-in-partition-key.md)
