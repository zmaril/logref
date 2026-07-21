---
message: "could not obtain pre-existing subscriptions: %s"
slug: could-not-obtain-pre-existing-subscriptions
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1324"
reproduced: false
---

# `could not obtain pre-existing subscriptions: %s`

## What it means

`pg_createsubscriber` queried the target for subscriptions that already exist and the query failed. The `%s` value gives the reason. It checks existing subscriptions so it does not conflict with them.

## When it happens

It happens during subscriber setup when the query for existing subscriptions fails — usually a connection problem or missing privileges on the target.

## How to fix

Confirm the target connection works and the role can read `pg_subscription`, then rerun. The included reason usually names the cause.

## Example

*Illustrative* — the existing-subscriptions query failed.

```text
pg_createsubscriber: error: could not obtain pre-existing subscriptions: connection to server failed
```

## Related

- [could not obtain subscriber settings](./could-not-obtain-subscriber-settings.md)
- [could not obtain subscription OID](./could-not-obtain-subscription-oid.md)
