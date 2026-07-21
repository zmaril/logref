---
message: "could not end lz4 compression: %s"
slug: could-not-end-lz4-compression
passthrough: false
api: [elog, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/backup/basebackup_lz4.c:251"
  - "postgres/src/fe_utils/astreamer_lz4.c:243"
reproduced: false
---

# `could not end lz4 compression: %s`

## What it means

Code compressing with LZ4 (base backup streaming or a frontend stream) failed to finalize the LZ4 compression frame. The placeholder is the library reason. The closing step that flushes the last compressed bytes did not succeed.

## When it happens

Finishing an LZ4-compressed base backup or stream when the LZ4 library reports an error, or an I/O failure interrupts the final flush.

## How to fix

Check the library reason and any accompanying I/O error. Ensure the output destination is healthy and has space, and that the LZ4 library is functioning. Treat a stream that failed to finalize as incomplete and regenerate it.

## Example

*Illustrative* — LZ4 compression that could not be finalized.

```text
ERROR:  could not end lz4 compression: error 1
```

## Related

- [could not create lz4 compression context](./could-not-create-lz4-compression-context.md)
- [could not enable long-distance mode](./could-not-enable-long-distance-mode.md)
