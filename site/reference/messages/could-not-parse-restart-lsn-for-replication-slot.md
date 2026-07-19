---
message: "could not parse restart_lsn \"%s\" for replication slot \"%s\""
slug: could-not-parse-restart-lsn-for-replication-slot
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/streamutil.c:557"
reproduced: false
---

# `could not parse restart_lsn "%s" for replication slot "%s"`

## What it means

A `pg_basebackup`-family tool read a replication slot's `restart_lsn` and could not parse the WAL position. The `%s` values give the raw text and the slot name. The `restart_lsn` marks the oldest WAL the slot still needs.

## When it happens

It happens while a tool inspects a replication slot, when the slot's `restart_lsn` value is not a valid WAL position — usually a protocol or version mismatch, or an unexpected slot state (for example a slot with no reserved position yet).

## How to fix

Make sure the client and server versions are compatible. Confirm the slot is in a normal state with a reserved WAL position; a freshly created slot that has not reserved WAL yet can present this way. If versions match and the slot is healthy, capture the text and report a reproducible case.

## Example

*Illustrative* — an unparsable restart_lsn for a slot.

```text
pg_basebackup: error: could not parse restart_lsn "" for replication slot "my_slot"
```

## Related

- [could not parse start position](./could-not-parse-start-position.md)
- [could not parse next timeline's starting point](./could-not-parse-next-timeline-s-starting-point.md)
