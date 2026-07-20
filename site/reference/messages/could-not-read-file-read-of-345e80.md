---
message: "could not read file \"%s\": read %d of %zu"
slug: could-not-read-file-read-of-345e80
passthrough: false
api: [ereport, pg_fatal, pg_log_error]
level: [ERROR, FATAL, PANIC]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:3535"
  - "postgres/src/backend/access/transam/xlog.c:4433"
  - "postgres/src/backend/replication/logical/origin.c:789"
  - "postgres/src/backend/replication/logical/origin.c:827"
  - "postgres/src/backend/replication/logical/snapbuild.c:1958"
  - "postgres/src/backend/replication/slot.c:2749"
  - "postgres/src/backend/replication/slot.c:2790"
  - "postgres/src/backend/replication/walsender.c:687"
  - "postgres/src/backend/utils/cache/relmapper.c:832"
  - "postgres/src/bin/pg_rewind/file_ops.c:367"
  - "postgres/src/bin/pg_rewind/parsexlog.c:373"
  - "postgres/src/common/controldata_utils.c:115"
  - "postgres/src/common/controldata_utils.c:120"
reproduced: false
---

# `could not read file "%s": read %d of %zu`

## What it means

A read returned fewer bytes than expected — the file is shorter than it should be. The placeholders are the path, the number of bytes actually read, and the number requested. Unlike a failed `read()`, the call succeeded but hit end-of-file early, which for WAL, control, or relation files means truncation or corruption.

## When it happens

Reading a WAL segment, the control file, a relation page, or a backup file that has been truncated — often by a crash during write, a partial copy, a filesystem problem, or an incomplete restore. The `DATA_CORRUPTED` SQLSTATE marks it as an integrity problem.

## How to fix

Treat a short read of critical files as corruption. For a truncated WAL segment during recovery, you may need to restore the segment from the archive or from a backup. For a relation file, verify with `amcheck` and restore the affected data from a known-good backup. Investigate why the file was short — a crash mid-write, a bad copy, or failing storage.

## Example

*Illustrative* — a truncated WAL segment during recovery.

```text
PANIC:  could not read file "pg_wal/000000010000000000000004": read 4096 of 8192
```

## Related

- [could not read file](./could-not-read-file-54f73a.md)
- [invalid snapshot data in file](./invalid-snapshot-data-in-file.md)
