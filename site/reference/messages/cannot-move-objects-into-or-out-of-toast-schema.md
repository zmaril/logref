---
message: "cannot move objects into or out of TOAST schema"
slug: cannot-move-objects-into-or-out-of-toast-schema
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:3541"
reproduced: false
---

# `cannot move objects into or out of TOAST schema`

## What it means

An `ALTER ... SET SCHEMA` tried to move an object into or out of the `pg_toast` schema. The TOAST schema holds internally-managed out-of-line storage relations, so user objects cannot be moved across its boundary.

## When it happens

It occurs when a `SET SCHEMA` names `pg_toast` as the source or destination schema.

## How to fix

Do not move objects into or out of `pg_toast`. Leave TOAST relations to the engine, and move user objects between ordinary schemas only.

## Example

*Illustrative* — moving an object into pg_toast.

```text
ERROR:  cannot move objects into or out of TOAST schema
```

## Related

- [cannot move objects into or out of temporary schemas](./cannot-move-objects-into-or-out-of-temporary-schemas.md)
- [cannot lock rows in TOAST relation](./cannot-lock-rows-in-toast-relation.md)
