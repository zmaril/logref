---
message: "WAL directory \"%s\" not removed at user's request"
slug: wal-directory-not-removed-at-user-s-request
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:818"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:276"
reproduced: false
---

# `WAL directory "%s" not removed at user's request`

## What it means

A tool that would normally clean up a WAL directory left it in place because the user asked it to keep the directory.

## When it happens

It is printed at INFO by tools such as `pg_basebackup` when a `--no-clean`-style option (or an equivalent choice) tells it not to remove a WAL directory it created.

## Is this a problem?

This is expected when you asked to preserve the directory, for example to inspect it after a failure. No action is needed; remove the directory yourself when you are done with it.

## Example

*Illustrative* — a WAL directory preserved by request.

```text
INFO:  WAL directory "/var/lib/pg/wal_target" not removed at user's request
```

## Related

- [removing WAL directory](./removing-wal-directory.md)
- [removing contents of WAL directory](./removing-contents-of-wal-directory.md)
