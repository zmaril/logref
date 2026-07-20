---
message: "could not read from file \"%s\" at offset %d: read too few bytes"
slug: could-not-read-from-file-at-offset-read-too-few-bytes
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/slru.c:1129"
reproduced: false
---

# `could not read from file "%s" at offset %d: read too few bytes`

## What it means

The SLRU subsystem read from one of its segment files at a given offset but received fewer bytes than a full page. The read returned less than expected, which means the segment is truncated at that point.

## When it happens

It fires during normal operation when an SLRU segment (for example under `pg_xact` or `pg_multixact`) is shorter than expected at the requested offset — usually a truncated segment file or an I/O problem.

## How to fix

Treat a short SLRU read as corruption. Check the storage under the data directory for faults and confirm the segment files are intact. If a segment is truncated or lost, the cluster likely needs to be restored from a backup; capture the file name and offset for diagnosis.

## Example

*Illustrative* — a short read from an SLRU segment.

```text
ERROR:  could not read from file "pg_xact/0000" at offset 8192: read too few bytes
```

## Related

- [could not read from file at offset](./could-not-read-from-file-at-offset.md)
- [could not read from file: read instead of bytes](./could-not-read-from-file-read-instead-of-bytes.md)
