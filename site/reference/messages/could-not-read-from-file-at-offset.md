---
message: "could not read from file \"%s\" at offset %d: %m"
slug: could-not-read-from-file-at-offset
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/slru.c:1123"
reproduced: false
---

# `could not read from file "%s" at offset %d: %m`

## What it means

The SLRU subsystem — which manages fixed-size caches such as the commit-log and multixact data — tried to read from one of its segment files at a given offset and the read failed. The `%m` reason gives the cause.

## When it happens

It fires during normal operation when an SLRU segment (for example under `pg_xact` or `pg_multixact`) cannot be read at the requested offset — usually a missing or truncated segment file, or an I/O error.

## How to fix

Check the storage under the data directory for faults, and confirm the SLRU segment files are present and intact. A missing or damaged segment here indicates corruption; investigate the storage and, if data is lost, restore from a backup. Capture the file name and offset for diagnosis.

## Example

*Illustrative* — an SLRU segment read failed.

```text
ERROR:  could not read from file "pg_xact/0000" at offset 8192: Input/output error
```

## Related

- [could not read from file at offset: read too few bytes](./could-not-read-from-file-at-offset-read-too-few-bytes.md)
- [could not read from file: read instead of bytes](./could-not-read-from-file-read-instead-of-bytes.md)
