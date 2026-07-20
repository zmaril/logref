---
message: "invalid compression method %c"
slug: invalid-compression-method-b1b2db
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/common/toast_compression.c:313"
  - "postgres/src/backend/access/common/toast_internals.c:75"
reproduced: false
---

# `invalid compression method %c`

## What it means

A compression method code was not one of the methods this server understands. The placeholder is the single-character method identifier that was found.

## When it happens

It arises when reading a value or stream whose compression-method byte is unrecognized — for example a TOAST-compressed datum or a protocol/backup stream produced with a method not supported by this build, or corrupted data.

## How to fix

Make sure the data was produced by a build that supports the same compression methods, and that the reader supports them too. If a build lacks `lz4` or `zstd` support the corresponding data cannot be read; rebuild with that support or reproduce the data with a supported method. Corrupt input can also present this way.

## Example

*Illustrative* — an unknown compression-method byte.

```text
ERROR:  invalid compression method 'x'
```

## Related

- [LZ4 is not supported by this build](./lz4-is-not-supported-by-this-build.md)
- [invalid length in external bit string](./invalid-length-in-external-bit-string.md)
