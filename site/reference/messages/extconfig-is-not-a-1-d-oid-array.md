---
message: "extconfig is not a 1-D Oid array"
slug: extconfig-is-not-a-1-d-oid-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/extension.c:2959"
  - "postgres/src/backend/commands/extension.c:3148"
reproduced: false
---

# `extconfig is not a 1-D Oid array`

## What it means

Internal error. An extension's `extconfig` field in `pg_extension` was not the expected one-dimensional OID array. It is a catalog-shape guard read while handling extension configuration tables.

## When it happens

It fires when the `extconfig` catalog column is malformed. Ordinary use does not produce it; it indicates catalog damage or a hand-edit of the catalog.

## How to fix

This is a catalog-consistency guard. Do not edit `pg_extension` directly. If the array is malformed, restore from backup and investigate how the catalog was altered.

## Example

*Illustrative* — a malformed extconfig array.

```text
ERROR:  extconfig is not a 1-D Oid array
```

## Related

- [extcondition is not a 1-D text array](./extcondition-is-not-a-1-d-text-array.md)
- [extension does not exist](./extension-does-not-exist.md)
