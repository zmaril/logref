---
message: "could not write to data file for XID %u: %m"
slug: could-not-write-to-data-file-for-xid
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/reorderbuffer.c:4280"
reproduced: false
---

# `could not write to data file for XID %u: %m`

## What it means

Logical decoding could not write to the on-disk spill file for a transaction. The placeholder is the transaction ID and the trailing text is the operating-system error. The reorder buffer spills large in-progress transactions to disk.

## When it happens

It fires while a logical decoding process spills a transaction's changes to disk and a write fails — a full disk or an I/O error on the temporary area under the data directory.

## How to fix

Read the OS error. `No space left on device` means the data directory's filesystem is full; free space so decoding can proceed. An I/O error points at the storage. Large transactions spill more; raising `logical_decoding_work_mem` reduces spilling but the storage still needs room.

## Example

*Illustrative* — spilling a transaction ran out of space.

```text
ERROR:  could not write to data file for XID 1234: No space left on device
```

## Related

- [could not remove file during removal of xid](./could-not-remove-file-during-removal-of-xid.md)
- [could not write to file, wrote N of M](./could-not-write-to-file-wrote-of.md)
