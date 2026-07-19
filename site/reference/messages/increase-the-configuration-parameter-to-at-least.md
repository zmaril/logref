---
message: "Increase the configuration parameter \"%s\" to at least %d."
slug: increase-the-configuration-parameter-to-at-least
passthrough: false
api: [pg_log_error_hint]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1102"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1111"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1221"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1230"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1239"
reproduced: false
---

# `Increase the configuration parameter "%s" to at least %d.`

## What it means

A hint attached to a preceding error, advising that a named configuration parameter be raised to at least a given value. The placeholders are the parameter name and the minimum value. Here it comes from `pg_createsubscriber`, which needs enough replication slots/workers on the source to proceed.

## When it happens

Setting up logical replication (for example with `pg_createsubscriber`) when a resource parameter on the publisher — such as `max_replication_slots` or `max_logical_replication_workers` — is set too low for the number of subscriptions being created.

## How to fix

Raise the named parameter to at least the suggested value in `postgresql.conf` and restart (these replication parameters require a restart), then retry the operation. Read the primary error line above the hint to see which resource ran out.

## Example

*Illustrative* — a hint to raise a replication parameter.

```text
HINT:  Increase the configuration parameter "max_replication_slots" to at least 3.
```

## Related

- [the WAL segment size must be a power of two between 1 MB and 1 GB](./the-wal-segment-size-must-be-a-power-of-two-between-1-mb-and-1-gb.md)
- [replication slot does not exist](./replication-slot-does-not-exist.md)
