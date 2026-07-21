---
message: "out of memory while allocating a WAL reading processor"
slug: out-of-memory-while-allocating-a-wal-reading-processor
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/parsexlog.c:80"
  - "postgres/src/bin/pg_rewind/parsexlog.c:139"
  - "postgres/src/bin/pg_rewind/parsexlog.c:201"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1408"
reproduced: false
---

# `out of memory while allocating a WAL reading processor`

## What it means

A tool that replays or inspects WAL (here `pg_rewind`) could not allocate the reader state it needs to walk the write-ahead log. The WAL reading processor (an `XLogReaderState`) holds decode buffers; if the allocation fails, the tool cannot proceed and exits.

## When it happens

Running `pg_rewind` (or another WAL-reading utility) on a host that is out of memory or under a tight `ulimit`, so even the modest reader allocation is refused.

## How to fix

Free memory on the host or raise the process's memory limit, then re-run. Close other large processes, check `ulimit -v`, and make sure the machine is not already deep into swap. The reader itself is small, so this almost always reflects genuine memory pressure rather than a tool bug.

## Example

*Illustrative* — pg_rewind failing to allocate its WAL reader.

```text
out of memory while allocating a WAL reading processor
```

## Related

- [out of memory](./out-of-memory-0fea34.md)
- [could not find a valid record after](./could-not-find-a-valid-record-after-dd2f88.md)
