---
message: "cannot use the \"%s\" option on server versions older than PostgreSQL %s"
slug: cannot-use-the-option-on-server-versions-older-than-postgresql
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/scripts/reindexdb.c:302"
  - "postgres/src/bin/scripts/reindexdb.c:309"
  - "postgres/src/bin/scripts/vacuuming.c:200"
  - "postgres/src/bin/scripts/vacuuming.c:207"
  - "postgres/src/bin/scripts/vacuuming.c:214"
  - "postgres/src/bin/scripts/vacuuming.c:221"
  - "postgres/src/bin/scripts/vacuuming.c:228"
  - "postgres/src/bin/scripts/vacuuming.c:235"
  - "postgres/src/bin/scripts/vacuuming.c:242"
  - "postgres/src/bin/scripts/vacuuming.c:249"
  - "postgres/src/bin/scripts/vacuuming.c:256"
  - "postgres/src/bin/scripts/vacuuming.c:263"
  - "postgres/src/bin/scripts/vacuuming.c:270"
  - "postgres/src/bin/scripts/vacuuming.c:277"
reproduced: false
---

# `cannot use the "%s" option on server versions older than PostgreSQL %s`

## What it means

A client tool was asked to use an option that the target server is too old to support. The first placeholder is the option, the second the minimum required PostgreSQL version. The client understands the flag, but the server on the other end does not implement the feature it needs.

## When it happens

Running a newer `reindexdb`, `vacuumdb`, or similar utility with a modern option (for example concurrent reindex, or a parallel/filter flag) against an older server that predates that capability.

## How to fix

Either drop the unsupported option, or upgrade the target server to at least the named version. When administering a mixed fleet, gate newer options on the server version. The message tells you exactly which release first supports the option.

## Example

*Illustrative* — a modern reindexdb option against an old server.

```sh
reindexdb --concurrently mydb   # server is PostgreSQL 11
```

Produces:

```text
reindexdb: error: cannot use the "concurrently" option on server versions older than PostgreSQL 12
```

## Related

- [cannot use the option when performing only analyze](./cannot-use-the-option-when-performing-only-analyze.md)
- [this build does not support compression with %s](./this-build-does-not-support-compression-with.md)
