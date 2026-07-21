---
message: "updated partition constraint for default partition \"%s\" would be violated by some row"
slug: updated-partition-constraint-for-default-partition-would-be-violated-by-some-row
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CHECK_VIOLATION
    code: "23514"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:6634"
  - "postgres/src/backend/partitioning/partbounds.c:3379"
reproduced: false
---

# `updated partition constraint for default partition "%s" would be violated by some row`

## What it means

Attaching a new partition, or adding one, would change the implicit constraint on the default partition so that some row already stored in the default partition would no longer satisfy it.

## When it happens

It arises from `ALTER TABLE ... ATTACH PARTITION` (or `CREATE TABLE ... PARTITION OF`) when the default partition holds rows whose key values fall into the range or list the new partition claims.

## How to fix

Move or delete the conflicting rows from the default partition before attaching the new partition — those rows belong in the incoming partition. Query the default partition for keys in the new partition's bounds, relocate them, then retry the attach.

## Example

*Illustrative* — attaching a partition that conflicts with default rows.

```text
ERROR:  updated partition constraint for default partition "sales_default" would be violated by some row
```

## Related

- [with check option is supported only on automatically updatable views](./with-check-option-is-supported-only-on-automatically-updatable-views.md)
- [unique constraints are not supported on foreign tables](./unique-constraints-are-not-supported-on-foreign-tables.md)
