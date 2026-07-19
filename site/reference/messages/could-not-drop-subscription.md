---
message: "could not drop subscription \"%s\": %s"
slug: could-not-drop-subscription
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1289"
reproduced: false
---

# `could not drop subscription "%s": %s`

## What it means

`pg_createsubscriber` could not drop a subscription on the target database during cleanup or rollback. The `%s` gives the server's error.

## When it happens

It happens during `pg_createsubscriber` when `DROP SUBSCRIPTION` on the target fails — for example the subscription's slot could not be reached, or the connecting role lacks privileges.

## How to fix

Check the attached server error. If a slot could not be dropped, detach it with `ALTER SUBSCRIPTION ... SET (slot_name = NONE)` and then drop the subscription. Confirm the role owns the subscription.

## Example

*Illustrative* — subscription cleanup failing.

```text
pg_createsubscriber: error: could not drop subscription "pg_cs_sub": ...
```

## Related

- [could not create subscription in database](./could-not-create-subscription-in-database.md)
- [could not enable subscription](./could-not-enable-subscription.md)
