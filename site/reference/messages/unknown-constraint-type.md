---
message: "unknown constraint type"
slug: unknown-constraint-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:991"
  - "postgres/src/backend/commands/indexcmds.c:1208"
reproduced: false
---

# `unknown constraint type`

## What it means

Internal error. Constraint-handling code met a constraint-type code that is not one of the defined kinds (check, foreign key, unique, primary key, exclusion, and so on).

## When it happens

It fires where a constraint's type is switched on and the value is outside the known set — a sign of an inconsistent `pg_constraint` row, not of ordinary DDL.

## How to fix

This is an internal guard. If routine constraint DDL triggers it, capture the constraint definition and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized constraint type.

```text
ERROR:  unknown constraint type
```

## Related

- [unknown attrKind %u](./unknown-attrkind.md)
- [unrecognized FK action type: %d](./unrecognized-fk-action-type.md)
