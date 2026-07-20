---
message: "could not seek to block %u in shared tuplestore temporary file"
slug: could-not-seek-to-block-in-shared-tuplestore-temporary-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/sort/sharedtuplestore.c:546"
reproduced: false
---

# `could not seek to block %u in shared tuplestore temporary file`

## What it means

A parallel query could not seek to a specific block in a shared tuplestore's temporary file. The placeholder is the block number. A shared tuplestore lets cooperating worker processes read tuples that were spilled to a temporary file.

## When it happens

It fires during parallel execution — for example a parallel hash join — when a worker repositions within the shared spill file and the seek fails, pointing at an I/O problem or a damaged temporary file.

## How to fix

Check the storage holding the server's temporary files (`temp_tablespaces` or the default) for I/O errors or a full disk. As a stopgap, disabling parallelism for the query with `SET max_parallel_workers_per_gather = 0` avoids the shared tuplestore path. Fix the underlying temporary-file storage for a real resolution.

## Example

*Illustrative* — a seek in a shared spill file failed.

```text
ERROR:  could not seek to block 512 in shared tuplestore temporary file
```

## Related

- [could not seek in file to offset](./could-not-seek-in-file-to-offset.md)
- [could not send tuple to shared-memory queue](./could-not-send-tuple-to-shared-memory-queue.md)
