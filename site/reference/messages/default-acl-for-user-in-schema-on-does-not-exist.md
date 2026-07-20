---
message: "default ACL for user \"%s\" in schema \"%s\" on %s does not exist"
slug: default-acl-for-user-in-schema-on-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:2166"
reproduced: false
---

# `default ACL for user "%s" in schema "%s" on %s does not exist`

## What it means

A command referenced a default-privileges entry (from `ALTER DEFAULT PRIVILEGES`) for a specific role, schema, and object type, and no such entry exists. The placeholders are the role, the schema, and the object-type name.

## When it happens

It fires when resolving an object address for a default ACL — for example a `COMMENT` or `SECURITY LABEL` on default privileges, or internal dependency lookups — when the referenced default-privileges set was never defined or was already reset.

## How to fix

List existing default-privilege entries with `\ddp` in psql, or query `pg_default_acl`. Create the entry first with `ALTER DEFAULT PRIVILEGES FOR ROLE ... IN SCHEMA ... GRANT ...`, and match the role, schema, and object type exactly.

## Example

*Illustrative* — referencing a default ACL that was never set.

```text
ERROR:  default ACL for user "app" in schema "public" on tables does not exist
```

## Related

- [default ACL for user on ... does not exist](./default-acl-for-user-on-does-not-exist.md)
- [default privileges cannot be set for columns](./default-privileges-cannot-be-set-for-columns.md)
