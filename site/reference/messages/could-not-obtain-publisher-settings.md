---
message: "could not obtain publisher settings: %s"
slug: could-not-obtain-publisher-settings
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1065"
reproduced: false
---

# `could not obtain publisher settings: %s`

## What it means

`pg_createsubscriber` queried the source (publisher) server for the configuration settings it needs and the query failed. The `%s` value gives the reason. It reads settings such as WAL level and replication limits to check the source is usable.

## When it happens

It happens during setup while probing the publisher, when the settings query fails — usually a connection problem or missing privileges on the source.

## How to fix

Confirm the publisher connection works and the role can read server settings, then rerun. The included reason usually names the cause; make sure the source is configured for logical replication (`wal_level = logical`).

## Example

*Illustrative* — the publisher-settings query failed.

```text
pg_createsubscriber: error: could not obtain publisher settings: connection to server failed
```

## Related

- [could not obtain subscriber settings](./could-not-obtain-subscriber-settings.md)
- [could not obtain recovery progress](./could-not-obtain-recovery-progress.md)
