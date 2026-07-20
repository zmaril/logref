---
message: "user mapping for \"%s\" does not exist for server \"%s\""
slug: user-mapping-for-does-not-exist-for-server
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/foreigncmds.c:1358"
  - "postgres/src/backend/commands/foreigncmds.c:1478"
reproduced: false
---

# `user mapping for "%s" does not exist for server "%s"`

## What it means

An operation on a foreign server needed a user mapping for the current (or named) user, and no mapping is defined for that user on that server.

## When it happens

It arises when querying a foreign table, or dropping a mapping, and no `USER MAPPING` exists linking the role to the foreign server — the mapping was never created or was created for a different role.

## How to fix

Create the mapping with `CREATE USER MAPPING FOR <role> SERVER <server> OPTIONS (...)`, supplying the credentials the wrapper needs. A `PUBLIC` mapping can serve as a fallback for roles without their own.

## Example

*Illustrative* — a missing user mapping.

```text
ERROR:  user mapping for "app" does not exist for server "remote"
```

## Related

- [user mapping for user "%s" on server "%s" does not exist](./user-mapping-for-user-on-server-does-not-exist.md)
- [unique constraints are not supported on foreign tables](./unique-constraints-are-not-supported-on-foreign-tables.md)
