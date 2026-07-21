---
message: "cannot use generated column in partition key"
slug: cannot-use-generated-column-in-partition-key
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:20563"
  - "postgres/src/backend/commands/tablecmds.c:20645"
reproduced: true
---

# `cannot use generated column in partition key`

## What it means

A `PARTITION BY` clause referenced a generated column. The partition key must be based on stored, directly supplied values; a generated column is derived from other columns and is not permitted in the partition key.

## When it happens

Defining a partitioned table whose partition key expression or column list includes a `GENERATED ALWAYS AS` column.

## How to fix

Partition on the underlying columns the generated column is computed from, or on ordinary stored columns. If you need to partition by the computed value, express that computation directly in the `PARTITION BY` expression rather than referencing the generated column.

## Example

*Reproduced* — captured from `reproducers/scenarios/36_constraints_partitioning.sql`.

```sql
CREATE TABLE s36.pk_gen (a int, b int GENERATED ALWAYS AS (a) STORED) PARTITION BY RANGE (b);
```

Produces:

```text
ERROR:  cannot use generated column in partition key
```

## Related

- [cannot insert a non-DEFAULT value into column](./cannot-insert-a-non-default-value-into-column.md)
- [child column specifies generation expression](./child-column-specifies-generation-expression.md)
