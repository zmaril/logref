---
message: "default ACL for user \"%s\" on %s does not exist"
slug: default-acl-for-user-on-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:2171"
reproduced: false
---

# `default ACL for user "%s" on %s does not exist`

## What it means

A command referenced a default-privileges entry for a role and object type that is not scoped to any schema, and no such entry exists. The placeholders are the role and the object-type name.

## When it happens

It fires when resolving an object address for a schema-independent default ACL and the `ALTER DEFAULT PRIVILEGES` set it names was never created or was already reset to the default state.

## How to fix

List the existing entries with `\ddp` or query `pg_default_acl`. Define the default privileges first with `ALTER DEFAULT PRIVILEGES FOR ROLE ... GRANT ...` and reference the exact role and object type.

## Example

*Illustrative* — referencing a global default ACL that does not exist.

```text
ERROR:  default ACL for user "app" on schemas does not exist
```

## Related

- [default ACL for user in schema on ... does not exist](./default-acl-for-user-in-schema-on-does-not-exist.md)
- [default privileges cannot be set for columns](./default-privileges-cannot-be-set-for-columns.md)
