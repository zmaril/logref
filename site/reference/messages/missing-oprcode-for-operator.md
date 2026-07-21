---
message: "missing oprcode for operator %u"
slug: missing-oprcode-for-operator
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtpreprocesskeys.c:2610"
  - "postgres/src/backend/commands/repack.c:3131"
reproduced: false
---

# `missing oprcode for operator %u`

## What it means

Internal error. An operator's catalog row lacks the underlying function (`oprcode`) that implements it. The placeholder is the operator OID. Every usable operator must reference an implementing function.

## When it happens

It fires when the executor or planner resolves an operator to its function and finds none. Normally created operators always have `oprcode`; this points to corrupted `pg_operator` data or a partially defined operator.

## How to fix

This is a can't-happen guard. If a specific operator triggers it, its definition is incomplete or its catalog row is damaged — recreate the operator with a valid `PROCEDURE`. Capture the operator and report a reproducible case.

## Example

*Illustrative* — an operator with no implementing function.

```text
ERROR:  missing oprcode for operator 16610
```

## Related

- [operator cannot be its own negator](./operator-cannot-be-its-own-negator.md)
- [missing operator in partition opfamily](./missing-operator-in-partition-opfamily.md)
