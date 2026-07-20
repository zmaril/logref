---
message: "could not write init file: %m"
slug: could-not-write-init-file
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/cache/relcache.c:6680"
  - "postgres/src/backend/utils/cache/relcache.c:6783"
  - "postgres/src/backend/utils/cache/relcache.c:6835"
  - "postgres/src/backend/utils/cache/relcache.c:6839"
reproduced: false
---

# `could not write init file: %m`

## What it means

The server failed to write the relation-cache initialization file (`pg_internal.init`), a cached copy of critical catalog data used to speed startup. The `%m` is the OS error. Because it fires at `FATAL` here, the failure aborts the current operation.

## When it happens

Writing the relcache init file when the data directory is not writable by the server user, the filesystem is full or read-only, or storage errors occur.

## How to fix

Read the `%m` text. Ensure the data (and per-database) directory is writable by the server user and has free space. The init file is a rebuildable cache — if a stale one is causing trouble it can be removed and will be regenerated — but a write failure points to a permissions or storage problem to fix at the OS level.

## Example

*Illustrative* — an unwritable relcache init file.

```text
FATAL:  could not write init file: No space left on device
```

## Related

- [could not open file for writing](./could-not-open-file-for-writing.md)
- [could not open log file](./could-not-open-log-file-bcff37.md)
