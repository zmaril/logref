---
message: "ALTER TYPE ADD BEFORE/AFTER is incompatible with binary upgrade"
slug: alter-type-add-before-after-is-incompatible-with-binary-upgrade
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/catalog/pg_enum.c:484"
reproduced: false
---

# `ALTER TYPE ADD BEFORE/AFTER is incompatible with binary upgrade`

## What it means

An `ALTER TYPE ... ADD VALUE ... BEFORE/AFTER` was attempted during a binary upgrade, where the enum value's placement must be reproduced by OID rather than by relative position.

## When it happens

It occurs while `pg_upgrade` restores schema in binary-upgrade mode and an enum-add uses `BEFORE`/`AFTER` positioning, which the upgrade path handles differently.

## How to fix

This is a constraint of the binary-upgrade process, which restores enum values with fixed OIDs rather than by position. It normally only appears when manually running dump output in binary-upgrade mode; let `pg_upgrade` manage enum values, and add ordinary enum values with `ALTER TYPE ... ADD VALUE` outside upgrade mode.

## Example

*Illustrative* — positioned enum add during a binary upgrade.

```text
ERROR:  ALTER TYPE ADD BEFORE/AFTER is incompatible with binary upgrade
```

## Related

- [array of serial is not implemented](./array-of-serial-is-not-implemented.md)
- [alter action cannot be performed on relation](./alter-action-cannot-be-performed-on-relation.md)
