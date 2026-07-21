---
message: "empty range bound specified for partition \"%s\""
slug: empty-range-bound-specified-for-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/partitioning/partbounds.c:3118"
  - "postgres/src/backend/partitioning/partbounds.c:5373"
reproduced: true
---

# `empty range bound specified for partition "%s"`

## What it means

A `CREATE TABLE ... PARTITION OF ... FOR VALUES FROM (...) TO (...)` defined a range whose lower bound is not below its upper bound. The `%s` is the partition name. An empty or inverted range holds no rows.

## When it happens

Declaring a range partition where `FROM` equals or exceeds `TO`, so the bound describes an empty interval.

## How to fix

Set the range so the `FROM` bound is strictly less than the `TO` bound. Correct the values that produced an empty or reversed interval.

## Example

*Reproduced* — captured from `reproducers/scenarios/21_ddl_objects.sql`.

```sql
CREATE TABLE repro.pt_p1 PARTITION OF repro.pt FOR VALUES FROM (10) TO (1);
```

Produces:

```text
ERROR:  empty range bound specified for partition "pt_p1"
```

## Related

- [incompatible NOT VALID constraint on relation](./incompatible-not-valid-constraint-on-relation.md)
- [foreign key constraint cannot be implemented](./foreign-key-constraint-cannot-be-implemented.md)
