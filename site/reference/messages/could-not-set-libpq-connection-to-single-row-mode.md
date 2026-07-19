---
message: "could not set libpq connection to single row mode"
slug: could-not-set-libpq-connection-to-single-row-mode
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/libpq_source.c:479"
reproduced: false
---

# `could not set libpq connection to single row mode`

## What it means

`pg_rewind` could not switch its libpq connection to single-row mode. That mode makes the client library hand back one row at a time instead of buffering a whole result, which the tool relies on for streaming large results.

## When it happens

It fires while `pg_rewind` sets up a query against a live source server and the call to enable single-row mode fails.

## How to fix

This is an internal setup step and rarely reflects a user mistake. It can appear with a client library and server that disagree on protocol capabilities; make sure the `pg_rewind` version matches or exceeds the source server and that libpq is the expected build. Capture the log if it persists on matched versions.

## Example

*Illustrative* — single-row mode could not be enabled.

```text
pg_rewind: error: could not set libpq connection to single row mode
```

## Related

- [could not read restore_command from target cluster](./could-not-read-restore-command-from-target-cluster.md)
- [could not obtain (pg_createsubscriber connection)](./could-not-set-replication-progress-for-subscription.md)
