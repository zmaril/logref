---
message: "could not duplicate stdout: %m"
slug: could-not-duplicate-stdout
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/fe_utils/astreamer_gzip.c:127"
reproduced: false
---

# `could not duplicate stdout: %m`

## What it means

A frontend tool using gzip compression could not duplicate its standard-output descriptor. The `%m` reason gives the OS error. It duplicates stdout to write compressed data to it safely.

## When it happens

It happens when a tool writes a gzip-compressed stream to standard output and the `dup` of the descriptor fails, usually from file-descriptor exhaustion.

## How to fix

Check the host's file-descriptor limits (`ulimit -n`) and reduce concurrent load, then rerun.

## Example

*Illustrative* — a failed stdout duplication.

```text
fatal: could not duplicate stdout: Too many open files
```

## Related

- [could not create compressed file](./could-not-create-compressed-file.md)
- [could not end decompression](./could-not-end-decompression.md)
