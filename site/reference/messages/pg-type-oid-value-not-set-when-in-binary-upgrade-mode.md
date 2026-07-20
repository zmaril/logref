---
message: "pg_type OID value not set when in binary upgrade mode"
slug: pg-type-oid-value-not-set-when-in-binary-upgrade-mode
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/catalog/pg_type.c:131"
  - "postgres/src/backend/catalog/pg_type.c:470"
reproduced: false
---

# `pg_type OID value not set when in binary upgrade mode`

## What it means

Internal error raised only during binary-upgrade mode (used by `pg_upgrade`). Creating a type required a preassigned OID for the new `pg_type` row, and none had been supplied, so the operation cannot preserve OIDs as an upgrade requires.

## When it happens

It fires when `pg_dump --binary-upgrade` output that should have set the type OID via the upgrade support functions did not, and the server refuses to invent one. It signals a mismatch between the dump and the server, not a user action.

## How to fix

This is an internal upgrade guard. Ensure `pg_dump` and the target server are from compatible versions and that the dump was produced with `--binary-upgrade` (as `pg_upgrade` does automatically). If it occurs under a normal `pg_upgrade` run, capture both versions and report it.

## Example

*Illustrative* — a binary-upgrade type creation missing its preassigned OID.

```text
ERROR:  pg_type OID value not set when in binary upgrade mode
```

## Related

- [record type has not been registered](./record-type-has-not-been-registered.md)
- [type %u does not match constructor type](./type-does-not-match-constructor-type.md)
