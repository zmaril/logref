---
message: "cannot change TOAST relation \"%s\""
slug: cannot-change-toast-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1105"
reproduced: false
---

# `cannot change TOAST relation "%s"`

## What it means

A statement targeted a TOAST table directly for a change it does not allow. TOAST tables store the out-of-line portions of large values and are managed automatically, so they cannot be altered like ordinary tables. The placeholder is the TOAST relation name.

## When it happens

It occurs when a command tries to modify a `pg_toast` companion table directly.

## How to fix

Operate on the main table, not its TOAST companion. TOAST storage is maintained by the system and is not altered by the user.

## Example

*Illustrative* — altering a TOAST relation.

```text
ERROR:  cannot change TOAST relation "pg_toast_16384"
```

## Related

- [cannot change schema of toast table](./cannot-change-schema-of-toast-table.md)
- [cannot change relation](./cannot-change-relation.md)
