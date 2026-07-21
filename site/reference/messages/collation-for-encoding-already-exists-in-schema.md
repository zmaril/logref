---
message: "collation \"%s\" for encoding \"%s\" already exists in schema \"%s\""
slug: collation-for-encoding-already-exists-in-schema
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/commands/collationcmds.c:408"
reproduced: false
---

# `collation "%s" for encoding "%s" already exists in schema "%s"`

## What it means

A `CREATE COLLATION` produced a collation whose name and encoding pair already exists in the target schema. Collations are keyed by name and encoding, so a duplicate for the same encoding is rejected.

## When it happens

It occurs on `CREATE COLLATION` when a collation of the same name and for the same encoding already exists in the schema.

## How to fix

Choose a different name, drop the existing collation, or target a different encoding. Confirm whether a same-named collation for another encoding is what you intended.

## Example

*Illustrative* — a duplicate name-and-encoding collation.

```text
ERROR:  collation "mycoll" for encoding "UTF8" already exists in schema "public"
```

## Related

- [collation already exists in schema](./collation-already-exists-in-schema.md)
- [collation for encoding does not exist](./collation-for-encoding-does-not-exist.md)
