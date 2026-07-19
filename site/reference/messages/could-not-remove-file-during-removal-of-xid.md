---
message: "could not remove file \"%s\" during removal of %s/%s/xid*: %m"
slug: could-not-remove-file-during-removal-of-xid
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/reorderbuffer.c:4904"
reproduced: false
---

# `could not remove file "%s" during removal of %s/%s/xid*: %m`

## What it means

Logical decoding tried to delete a spill file it had written for a transaction and the delete failed. The reorder buffer spills large in-progress transactions to disk, and cleanup of one of those files did not succeed. The trailing text is the operating-system error.

## When it happens

It fires while a logical replication walsender or decoding process cleans up after a transaction whose changes were spilled to disk, when the file cannot be removed — a permission problem or an I/O error on the temporary area.

## How to fix

Read the OS error. A permission or ownership problem on the spill directory under the data directory is the usual cause; the `postgres` OS user must be able to remove its own temporary files. Check the storage for I/O errors. Leftover spill files waste space but do not corrupt data.

## Example

*Illustrative* — a spill file could not be removed.

```text
ERROR:  could not remove file "pg_replslot/sub/xid-1234-lsn-0-5000000.spill" during removal of pg_replslot/sub/xid*: Permission denied
```

## Related

- [could not write to data file for XID](./could-not-write-to-data-file-for-xid.md)
- [could not rewind temporary file](./could-not-rewind-temporary-file.md)
