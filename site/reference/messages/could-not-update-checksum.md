---
message: "could not update checksum"
slug: could-not-update-checksum
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/backup/basebackup.c:1994"
reproduced: false
---

# `could not update checksum`

## What it means

Code building a base backup could not update the running checksum over the backup data. The manifest records a checksum for each file, computed incrementally as the file is read. This is an internal failure in that computation.

## When it happens

It fires during a base backup while the server feeds file contents through the checksum routine and the update step fails, which is not expected on a healthy build.

## How to fix

This is an internal guard rather than a user error. It can accompany an underlying cryptographic-library problem. Confirm the server build is healthy, retry the backup, and if it recurs capture the surrounding log for a report. Choosing a different manifest checksum algorithm is a possible workaround if one algorithm is implicated.

## Example

*Illustrative* — the manifest checksum update failed.

```text
ERROR:  could not update checksum
```

## Related

- [could not rewind temporary file](./could-not-rewind-temporary-file.md)
- [CRC is incorrect](./crc-is-incorrect.md)
