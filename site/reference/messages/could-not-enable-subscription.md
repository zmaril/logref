---
message: "could not enable subscription \"%s\": %s"
slug: could-not-enable-subscription
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2169"
reproduced: false
---

# `could not enable subscription "%s": %s`

## What it means

`pg_createsubscriber` could not enable the subscription it created after finishing setup. The `%s` gives the server's error. The subscription was left in a disabled state.

## When it happens

It happens near the end of `pg_createsubscriber` when `ALTER SUBSCRIPTION ... ENABLE` fails, for example because the connecting role lacks privileges or the subscription is in an unexpected state.

## How to fix

Check the attached server error, then enable the subscription by hand with `ALTER SUBSCRIPTION <name> ENABLE` once the cause is resolved. Confirm the role owns the subscription.

## Example

*Illustrative* — subscription enable failing.

```text
pg_createsubscriber: error: could not enable subscription "pg_cs_sub": ...
```

## Related

- [could not create subscription in database](./could-not-create-subscription-in-database.md)
- [could not drop subscription](./could-not-drop-subscription.md)
