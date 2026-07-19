---
message: "unrecognized FK action type: %d"
slug: unrecognized-fk-action-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:14448"
  - "postgres/src/backend/commands/tablecmds.c:14508"
reproduced: false
---

# `unrecognized FK action type: %d`

## What it means

Internal error. Foreign-key enforcement met a referential-action code (the `ON DELETE`/`ON UPDATE` action) that is not one of the defined actions.

## When it happens

It fires where a constraint's referential action is switched on and the value is outside the known set — a sign of an inconsistent constraint row, not of ordinary DML.

## How to fix

This is an internal guard. If routine foreign-key activity triggers it, capture the constraint definition and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized FK action.

```text
ERROR:  unrecognized FK action type: 120
```

## Related

- [unrecognized confmatchtype: %d](./unrecognized-confmatchtype.md)
- [unsupported %s action for foreign key constraint using PERIOD](./unsupported-action-for-foreign-key-constraint-using-period.md)
