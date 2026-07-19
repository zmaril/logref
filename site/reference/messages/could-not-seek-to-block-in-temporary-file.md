---
message: "could not seek to block %ld in temporary file"
slug: could-not-seek-to-block-in-temporary-file
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/gist/gistbuildbuffers.c:749"
  - "postgres/src/backend/access/gist/gistbuildbuffers.c:757"
reproduced: false
---

# `could not seek to block %ld in temporary file`

## What it means

Internal error while building a GiST index. The build's temporary buffering file could not seek to a block. The `%ld` is the block number. It is a low-level I/O guard in the index-build spill logic.

## When it happens

It fires during a GiST index build that buffers to a temporary file when a seek on that file fails — typically an underlying I/O or space problem on the temp area.

## How to fix

Check the temporary tablespace and disk for space and I/O errors. Ensure the temp area is healthy and has room for the build, then retry. Persistent failures point at the storage.

## Example

*Illustrative* — a seek failure in a GiST build's temp file.

```text
ERROR:  could not seek to block 42 in temporary file
```

## Related

- [could not open temporary file](./could-not-open-temporary-file.md)
- [could not seek in file](./could-not-seek-in-file.md)
