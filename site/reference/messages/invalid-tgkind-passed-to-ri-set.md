---
message: "invalid tgkind passed to ri_set"
slug: invalid-tgkind-passed-to-ri-set
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ri_triggers.c:1390"
  - "postgres/src/backend/utils/adt/ri_triggers.c:1433"
reproduced: false
---

# `invalid tgkind passed to ri_set`

## What it means

Internal error. Referential-integrity code received a trigger-kind argument that is not one of the values it handles (the `SET NULL`/`SET DEFAULT` variants). It is a consistency guard in the foreign-key enforcement machinery.

## When it happens

It fires from the RI trigger support function when its internal kind argument is out of range. Ordinary foreign-key activity does not surface it; it points to an internal bug.

## How to fix

This is a can't-happen guard. Capture the foreign-key definition and the statement that fired the trigger and report a reproducible case.

## Example

*Illustrative* — a bad trigger kind in RI enforcement.

```text
ERROR:  invalid tgkind passed to ri_set
```

## Related

- [invalid after-trigger event code](./invalid-after-trigger-event-code.md)
- [invalid action for foreign key constraint containing generated column](./invalid-action-for-foreign-key-constraint-containing-generated-column.md)
