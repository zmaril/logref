---
message: "cannot attach a typed table as partition"
slug: cannot-attach-a-typed-table-as-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:21068"
reproduced: true
---

# `cannot attach a typed table as partition`

## What it means

An `ALTER TABLE ... ATTACH PARTITION` named a typed table — one created with `OF type_name` — as the partition. A typed table takes its column definitions from a composite type, which is incompatible with being a partition of a partitioned table.

## When it happens

It occurs when the table being attached was created as `CREATE TABLE ... OF some_type`.

## How to fix

Use an ordinary table as the partition, with a matching column layout. A typed table cannot serve as a partition; recreate it as a standard table if it needs to join the partition hierarchy.

## Example

*Reproduced* — captured from `reproducers/scenarios/36_constraints_partitioning.sql`.

```sql
ALTER TABLE s36.p ATTACH PARTITION s36.typedchild FOR VALUES FROM (30) TO (40);
```

Produces:

```text
ERROR:  cannot attach a typed table as partition
```

## Related

- [cannot attach inheritance child as partition](./cannot-attach-inheritance-child-as-partition.md)
- [cannot change inheritance of typed table](./cannot-change-inheritance-of-typed-table.md)
