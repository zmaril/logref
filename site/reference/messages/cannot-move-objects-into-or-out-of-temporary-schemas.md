---
message: "cannot move objects into or out of temporary schemas"
slug: cannot-move-objects-into-or-out-of-temporary-schemas
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:3535"
reproduced: false
---

# `cannot move objects into or out of temporary schemas`

## What it means

An `ALTER ... SET SCHEMA` tried to move an object into or out of a temporary schema. Temporary schemas hold session-private temporary objects and are managed automatically, so objects cannot be moved across their boundary.

## When it happens

It occurs when a `SET SCHEMA` names a `pg_temp` schema as the source or destination, either directly or through the `pg_temp` alias.

## How to fix

Do not move objects into or out of temporary schemas. Create a temporary object where it belongs, or move permanent objects between permanent schemas only.

## Example

*Illustrative* — moving an object into a temp schema.

```text
ERROR:  cannot move objects into or out of temporary schemas
```

## Related

- [cannot move objects into or out of TOAST schema](./cannot-move-objects-into-or-out-of-toast-schema.md)
- [cannot move an owned sequence into another schema](./cannot-move-an-owned-sequence-into-another-schema.md)
