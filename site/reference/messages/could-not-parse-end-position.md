---
message: "could not parse end position \"%s\""
slug: could-not-parse-end-position
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:693"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:811"
reproduced: false
---

# `could not parse end position "%s"`

## What it means

`pg_receivewal` or `pg_recvlogical` could not parse the `--endpos` value passed on the command line. The `%s` is the string it was given. It expects a WAL LSN in `X/Y` form.

## When it happens

The `--endpos` argument was not a valid LSN — a typo, a wrong separator, or non-hex digits.

## How to fix

Pass `--endpos` as a valid LSN, for example `0/1A2B3C4`. Copy the value from `pg_current_wal_lsn()` or the tool's own output.

## Example

*Illustrative* — a malformed endpos value.

```text
pg_receivewal: error: could not parse end position "latest"
```

## Related

- [could not parse connection string](./could-not-parse-connection-string.md)
- [could not parse filename](./could-not-parse-filename.md)
