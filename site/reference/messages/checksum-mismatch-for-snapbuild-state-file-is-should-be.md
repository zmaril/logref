---
message: "checksum mismatch for snapbuild state file \"%s\": is %u, should be %u"
slug: checksum-mismatch-for-snapbuild-state-file-is-should-be
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/replication/logical/snapbuild.c:1832"
reproduced: false
---

# `checksum mismatch for snapbuild state file "%s": is %u, should be %u`

## What it means

The stored checksum of a logical-decoding snapshot-builder state file did not match its contents. The serialized snapbuild state is corrupt, so the decoding machinery cannot trust it.

## When it happens

It is reached while reading a `pg_logical/snapshots` state file during logical decoding, after storage damage or an incomplete write left the file inconsistent.

## How to fix

This signals corruption of serialized decoding state. The affected snapshot file can be removed so decoding rebuilds it, but investigate the storage-level cause first. Check disk health and recent crashes.

## Example

*Illustrative* — a corrupt snapbuild state file.

```text
ERROR:  checksum mismatch for snapbuild state file "pg_logical/snapshots/0-0.snap": is 123, should be 456
```

## Related

- [checksum mismatch for replication slot file is should be](./checksum-mismatch-for-replication-slot-file-is-should-be.md)
- [clearing exported snapshot in wrong transaction state](./clearing-exported-snapshot-in-wrong-transaction-state.md)
