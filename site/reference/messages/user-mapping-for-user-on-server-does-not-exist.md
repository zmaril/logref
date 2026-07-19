---
message: "user mapping for user \"%s\" on server \"%s\" does not exist"
slug: user-mapping-for-user-on-server-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:1923"
  - "postgres/src/backend/catalog/objectaddress.c:1949"
reproduced: false
---

# `user mapping for user "%s" on server "%s" does not exist`

## What it means

A `DROP USER MAPPING` (or a lookup) named a user and server combination for which no mapping is defined.

## When it happens

It arises from `DROP USER MAPPING FOR <role> SERVER <server>` when that specific mapping was never created, or from a lookup that expected one to exist.

## How to fix

Confirm the mapping exists — check `pg_user_mappings` — and use the exact role and server names. Use `DROP USER MAPPING IF EXISTS` to make the drop idempotent when the mapping may be absent.

## Example

*Illustrative* — dropping a non-existent user mapping.

```text
ERROR:  user mapping for user "app" on server "remote" does not exist
```

## Related

- [user mapping for "%s" does not exist for server "%s"](./user-mapping-for-does-not-exist-for-server.md)
- [unique constraints are not supported on foreign tables](./unique-constraints-are-not-supported-on-foreign-tables.md)
