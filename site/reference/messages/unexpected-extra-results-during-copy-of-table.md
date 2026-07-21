---
message: "unexpected extra results during COPY of table \"%s\""
slug: unexpected-extra-results-during-copy-of-table
passthrough: false
api: [pg_log_warning]
level: [WARNING]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_db.c:474"
  - "postgres/src/bin/pg_dump/pg_dump.c:2488"
reproduced: false
---

# `unexpected extra results during COPY of table "%s"`

## What it means

While copying a table over a connection, a tool received more result sets from the server than the copy protocol expected, indicating the connection was left in an unexpected state.

## When it happens

It is emitted at WARNING by tools such as `pg_dump` in parallel mode when a `COPY` finishes but the connection still has pending results, often after an error or a protocol desynchronization on that connection.

## Is this a problem?

This points at a connection that got out of step, frequently downstream of an earlier error. Look earlier in the output for the first failure, retry the dump, and check for a proxy or pooler between the tool and the server that could be interleaving traffic.

## Example

*Illustrative* — extra results left on a copy connection.

```text
WARNING:  unexpected extra results during COPY of table "public.orders"
```

## Related

- [warning from original dump file](./warning-from-original-dump-file.md)
- [archive file already exists](./archive-file-already-exists.md)
