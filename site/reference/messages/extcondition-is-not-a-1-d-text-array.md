---
message: "extcondition is not a 1-D text array"
slug: extcondition-is-not-a-1-d-text-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/extension.c:3004"
  - "postgres/src/backend/commands/extension.c:3215"
reproduced: false
---

# `extcondition is not a 1-D text array`

## What it means

Internal error. An extension's `extcondition` field in `pg_extension` was not the expected one-dimensional text array. It is a catalog-shape guard read during extension dump or configuration handling.

## When it happens

It fires when the `extcondition` catalog column holds a malformed value. Ordinary use does not produce it; it points at catalog damage or a faulty direct catalog modification.

## How to fix

This is a catalog-consistency guard. Do not modify `pg_extension` directly. Inspect the extension's configuration rows; if the array is malformed, restore the catalog from backup and report how it happened.

## Example

*Illustrative* — a malformed extcondition array.

```text
ERROR:  extcondition is not a 1-D text array
```

## Related

- [extconfig is not a 1-D Oid array](./extconfig-is-not-a-1-d-oid-array.md)
- [extension does not exist](./extension-does-not-exist.md)
