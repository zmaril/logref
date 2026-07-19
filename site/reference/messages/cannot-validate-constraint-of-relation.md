---
message: "cannot validate constraint \"%s\" of relation \"%s\""
slug: cannot-validate-constraint-of-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:13483"
reproduced: false
---

# `cannot validate constraint "%s" of relation "%s"`

## What it means

A `VALIDATE CONSTRAINT` was issued against a relation whose kind does not support validation of that constraint, such as a foreign table or a partitioned parent where the operation does not apply.

## When it happens

It occurs on `ALTER TABLE ... VALIDATE CONSTRAINT` when the target relation is of a type that cannot validate the named constraint.

## How to fix

Validate the constraint on the relation type that supports it, or validate on the individual partitions rather than the parent. Check the relation kind before running the command.

## Example

*Illustrative* — validating on an unsupported relation.

```text
ERROR:  cannot validate constraint "c" of relation "t"
```

## Related

- [cannot validate NOT ENFORCED constraint](./cannot-validate-not-enforced-constraint.md)
- [child table is missing constraint](./child-table-is-missing-constraint.md)
