---
message: "subscription owner \"%s\" does not have permission on foreign server \"%s\""
slug: subscription-owner-does-not-have-permission-on-foreign-server
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/catalog/pg_subscription.c:154"
  - "postgres/src/backend/commands/subscriptioncmds.c:2086"
reproduced: false
---

# `subscription owner "%s" does not have permission on foreign server "%s"`

## What it means

A logical replication subscription is owned by a role that lacks `USAGE` on the foreign server (or the equivalent privilege) it needs to connect. The placeholders are the owner role and the server. The subscription cannot use the connection under that owner.

## When it happens

It arises when a subscription's owner is a non-superuser without the required privilege on the foreign server used for the connection — for example after ownership changes or privilege revocations.

## How to fix

Grant the owner the needed privilege on the foreign server (`GRANT USAGE ON FOREIGN SERVER ... TO owner`), or change the subscription's owner to a role that has it. Ensure the owner can legitimately use the connection details.

## Example

*Illustrative* — a subscription owner without server access.

```text
ERROR:  subscription owner "repl_user" does not have permission on foreign server "remote_pg"
```

## Related

- [password is required](./password-is-required.md)
- [subscription with OID %u does not exist](./subscription-with-oid-does-not-exist.md)
