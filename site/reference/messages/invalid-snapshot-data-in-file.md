---
message: "invalid snapshot data in file \"%s\""
slug: invalid-snapshot-data-in-file
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TEXT_REPRESENTATION
    code: "22P02"
call_sites:
  - "postgres/src/backend/utils/time/snapmgr.c:1314"
  - "postgres/src/backend/utils/time/snapmgr.c:1319"
  - "postgres/src/backend/utils/time/snapmgr.c:1324"
  - "postgres/src/backend/utils/time/snapmgr.c:1339"
  - "postgres/src/backend/utils/time/snapmgr.c:1344"
  - "postgres/src/backend/utils/time/snapmgr.c:1349"
  - "postgres/src/backend/utils/time/snapmgr.c:1364"
  - "postgres/src/backend/utils/time/snapmgr.c:1369"
  - "postgres/src/backend/utils/time/snapmgr.c:1374"
  - "postgres/src/backend/utils/time/snapmgr.c:1488"
  - "postgres/src/backend/utils/time/snapmgr.c:1504"
  - "postgres/src/backend/utils/time/snapmgr.c:1529"
reproduced: false
---

# `invalid snapshot data in file "%s"`

## What it means

An exported snapshot file could not be parsed. The placeholder is the file name. Snapshot files (created by `pg_export_snapshot()` and used by `SET TRANSACTION SNAPSHOT`) have a specific format; content that does not match is rejected.

## When it happens

Passing a bad or stale snapshot id to `SET TRANSACTION SNAPSHOT`, a snapshot whose exporting transaction has ended, or a corrupted/hand-edited snapshot file. `pg_dump --jobs` and logical replication setup use exported snapshots and can surface this if the snapshot is no longer valid.

## How to fix

Use a snapshot id that is currently valid and whose exporting transaction is still open — snapshots do not persist across the exporter's transaction end. Re-export the snapshot and use it promptly. Do not construct or edit snapshot ids by hand; take them from `pg_export_snapshot()`.

## Example

*Illustrative* — importing an expired snapshot.

```sql
SET TRANSACTION SNAPSHOT '00000003-0000001B-1';
```

Produces:

```text
ERROR:  invalid snapshot identifier: "00000003-0000001B-1"
```

(The file-based form fires when the on-disk snapshot data is unparseable.)

## Related

- [could not read file: read %d of %zu](./could-not-read-file-read-of-345e80.md)
- [current transaction is aborted](./current-transaction-is-aborted-commands-ignored-until-end-of-transaction-block.md)
