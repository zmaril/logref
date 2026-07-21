---
message: "could not obtain subscriber settings: %s"
slug: could-not-obtain-subscriber-settings
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1195"
reproduced: false
---

# `could not obtain subscriber settings: %s`

## What it means

`pg_createsubscriber` queried the target (subscriber) server for the settings it needs and the query failed. The `%s` value gives the reason. It reads settings such as replication limits to check the target is usable.

## When it happens

It happens during setup while probing the subscriber, when the settings query fails — usually a connection problem or missing privileges on the target.

## How to fix

Confirm the target connection works and the role can read server settings, then rerun. The included reason usually names the cause; make sure the target allows enough replication slots and origins for the new subscriptions.

## Example

*Illustrative* — the subscriber-settings query failed.

```text
pg_createsubscriber: error: could not obtain subscriber settings: connection to server failed
```

## Related

- [could not obtain publisher settings](./could-not-obtain-publisher-settings.md)
- [could not obtain pre-existing subscriptions](./could-not-obtain-pre-existing-subscriptions.md)
