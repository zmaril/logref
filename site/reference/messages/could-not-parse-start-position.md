---
message: "could not parse start position \"%s\""
slug: could-not-parse-start-position
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:806"
reproduced: false
---

# `could not parse start position "%s"`

## What it means

`pg_recvlogical` was given a start position for logical replication and could not parse it as a WAL location. The `%s` value gives the text you supplied. The start position tells the server where to begin streaming.

## When it happens

It happens when running `pg_recvlogical` with a `--startpos` value that is not a valid WAL position, which must be written as two hex numbers separated by a slash.

## How to fix

Supply the start position in the correct `X/Y` hexadecimal WAL-location form (for example `0/16B3748`). Correcting the `--startpos` value resolves it.

## Example

*Illustrative* — a malformed start position.

```text
pg_recvlogical: fatal: could not parse start position "beginning"
```

## Related

- [could not parse restart_lsn for replication slot](./could-not-parse-restart-lsn-for-replication-slot.md)
- [could not parse next timeline's starting point](./could-not-parse-next-timeline-s-starting-point.md)
