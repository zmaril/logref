---
message: "could not fetch remote file \"%s\": %s"
slug: could-not-fetch-remote-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/libpq_source.c:647"
reproduced: false
---

# `could not fetch remote file "%s": %s`

## What it means

`pg_rewind` could not fetch the contents of a file from the source server. The `%s` values name the file and give the reason. A file the rewind needs could not be retrieved.

## When it happens

It happens during a `pg_rewind` run using a live source connection when fetching a specific file fails — a lost connection, a permissions issue, or a server error.

## How to fix

Check connectivity to the source server and its log for the failing request, and confirm the connecting role has the needed privileges. Resolve the problem and rerun the rewind.

## Example

*Illustrative* — a source file that cannot be fetched.

```text
pg_rewind: fatal: could not fetch remote file "global/pg_control": ...reason...
```

## Related

- [could not fetch file list](./could-not-fetch-file-list.md)
- [could not find previous WAL record at](./could-not-find-previous-wal-record-at-93eda7.md)
