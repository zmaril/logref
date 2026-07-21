---
message: "could not create compressed file \"%s\": %m"
slug: could-not-create-compressed-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/fe_utils/astreamer_gzip.c:115"
reproduced: false
---

# `could not create compressed file "%s": %m`

## What it means

A frontend tool using gzip compression could not create the compressed output file. The `%m` reason gives the OS error.

## When it happens

It happens while writing a gzip-compressed dump or backup stream when creating the output file fails, usually from a full destination filesystem or a permissions problem.

## How to fix

Check free space and permissions on the destination directory, then rerun. Writing to a different location with more room resolves a space problem.

## Example

*Illustrative* — a compressed output file that cannot be created.

```text
fatal: could not create compressed file "dump.gz": No space left on device
```

## Related

- [could not create timeline history file](./could-not-create-timeline-history-file.md)
- [could not create zstd decompression context](./could-not-create-zstd-decompression-context.md)
