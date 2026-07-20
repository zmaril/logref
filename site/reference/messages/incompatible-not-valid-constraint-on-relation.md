---
message: "incompatible NOT VALID constraint \"%s\" on relation \"%s\""
slug: incompatible-not-valid-constraint-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/catalog/pg_constraint.c:774"
  - "postgres/src/backend/commands/tablecmds.c:8450"
reproduced: false
---

# `incompatible NOT VALID constraint "%s" on relation "%s"`

## What it means

An operation found a `NOT VALID` constraint on a relation that is incompatible with what it needs. The `%s` values are the constraint and relation. The unvalidated constraint blocks the action or cannot be relied on.

## When it happens

Attaching a partition or performing DDL that depends on a constraint being valid, when a matching constraint exists only as `NOT VALID`.

## How to fix

Validate the constraint with `ALTER TABLE ... VALIDATE CONSTRAINT name` (after ensuring the data satisfies it), or adjust the operation so it does not require the unvalidated constraint.

## Example

*Illustrative* — a NOT VALID constraint blocking an operation.

```text
ERROR:  incompatible NOT VALID constraint "chk" on relation "orders"
```

## Related

- [empty range bound specified for partition](./empty-range-bound-specified-for-partition.md)
- [foreign key constraint cannot be implemented](./foreign-key-constraint-cannot-be-implemented.md)
