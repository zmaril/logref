---
message: "tablespace \"%s\" already exists"
slug: tablespace-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/commands/tablespace.c:310"
  - "postgres/src/backend/commands/tablespace.c:1004"
reproduced: false
---

# `tablespace "%s" already exists`

## What it means

A `CREATE TABLESPACE` named a tablespace that already exists. The placeholder is the tablespace name. Tablespace names are cluster-wide and must be unique.

## When it happens

It arises when creating a tablespace whose name is already taken — a re-run provisioning step, or a collision with an existing tablespace.

## How to fix

Use a different name, or use the existing tablespace. If replacing it, drop the old one first (only possible when it holds no objects). Make provisioning idempotent by checking `pg_tablespace` before creating.

## Example

*Illustrative* — creating a tablespace that already exists.

```text
ERROR:  tablespace "fastdisk" already exists
```

## Related

- [unacceptable tablespace name "%s"](./unacceptable-tablespace-name.md)
- [tablespace name "%s" contains a newline or carriage return character](./tablespace-name-contains-a-newline-or-carriage-return-character.md)
