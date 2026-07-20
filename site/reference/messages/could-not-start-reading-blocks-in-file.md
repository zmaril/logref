---
message: "could not start reading blocks %u..%u in file \"%s\": %m"
slug: could-not-start-reading-blocks-in-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/smgr/md.c:1042"
reproduced: false
---

# `could not start reading blocks %u..%u in file "%s": %m`

## What it means

The storage manager could not begin an asynchronous read of a range of blocks from a data file. The placeholders are the block range and the file, and the trailing text is the operating-system error. This is part of the server's asynchronous-I/O read path.

## When it happens

It fires when the server queues a multi-block read (for example during a prefetching scan) and the operation cannot be started — an I/O error, or a problem submitting the request to the async-I/O backend.

## How to fix

Read the OS error. An I/O failure points at the storage holding the relation; check the disk and kernel log. If it correlates with the io_uring path, switching `io_method` to `worker` or `sync` isolates whether the async backend is involved. Address the underlying storage or I/O-method problem.

## Example

*Illustrative* — starting a block read failed.

```text
ERROR:  could not start reading blocks 100..107 in file "base/16384/24576": Input/output error
```

## Related

- [could not setup io_uring queue](./could-not-setup-io-uring-queue.md)
- [could not seek to beginning of file](./could-not-seek-to-beginning-of-file.md)
