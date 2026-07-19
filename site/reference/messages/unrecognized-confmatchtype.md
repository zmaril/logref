---
message: "unrecognized confmatchtype: %d"
slug: unrecognized-confmatchtype
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ri_triggers.c:2407"
  - "postgres/src/backend/utils/adt/ruleutils.c:2668"
reproduced: false
---

# `unrecognized confmatchtype: %d`

## What it means

Internal error. Foreign-key handling met a match-type code (the `MATCH FULL`/`MATCH SIMPLE`/`MATCH PARTIAL` selector) outside the set it recognizes.

## When it happens

It fires where a constraint's match type is switched on and the value is not a known case — a sign of an inconsistent `pg_constraint` row, not of ordinary DDL.

## How to fix

This is an internal guard. If routine foreign-key operations trigger it, capture the constraint definition and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized match type.

```text
ERROR:  unrecognized confmatchtype: 102
```

## Related

- [unrecognized FK action type: %d](./unrecognized-fk-action-type.md)
- [unknown constraint type](./unknown-constraint-type.md)
