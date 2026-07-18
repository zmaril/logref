---
message: "reading stats file \"%s\""
slug: reading-stats-file
passthrough: false
api: [elog]
level: [DEBUG2]
call_sites:
  - "postgres/src/backend/utils/activity/pgstat.c:1845"
reproduced: true
---

# `reading stats file "%s"`

**Severity:** DEBUG2

## What it means

The cumulative statistics subsystem is loading a stats file from disk. Postgres persists activity counters (per-table and per-database stats used by autovacuum and `pg_stat_*` views) and reads them back at startup. The placeholder is the file path. This is a low-level `DEBUG2` trace, off by default.

## When it happens

Seen only when `log_min_messages` is turned up to `DEBUG2` or finer. It is emitted during statistics initialization at server start and when the stats machinery reloads persisted counters.

## Is this a problem?

This is internal debug tracing, not a problem. If it is cluttering your log, raise `log_min_messages` back toward `warning` or `info` — `DEBUG2` is far more verbose than production logging needs. There is nothing to act on in the message itself.

## Source

Emitted from [`postgres/src/backend/utils/activity/pgstat.c:1845`](https://github.com/postgres/postgres/blob/master/src/backend/utils/activity/pgstat.c#L1845).

## Related

- [checkpoint starting](./checkpoint-starting.md)
