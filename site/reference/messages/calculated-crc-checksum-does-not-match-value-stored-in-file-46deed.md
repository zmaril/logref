---
message: "calculated CRC checksum does not match value stored in file"
slug: calculated-crc-checksum-does-not-match-value-stored-in-file-46deed
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/misc/pg_controldata.c:49"
  - "postgres/src/backend/utils/misc/pg_controldata.c:89"
  - "postgres/src/backend/utils/misc/pg_controldata.c:180"
  - "postgres/src/backend/utils/misc/pg_controldata.c:221"
reproduced: false
---

# `calculated CRC checksum does not match value stored in file`

## What it means

A file with an embedded CRC checksum (here read by `pg_controldata`) failed verification: the checksum computed over the contents does not match the one stored in the file. This signals the file is corrupted, truncated, or from an incompatible version/build.

## When it happens

Reading `pg_control` (or a similar checksummed file) that has been damaged, partially written, produced by a different Postgres major version, or from a build with a different layout than the tool expects.

## How to fix

Confirm the tool and the cluster are the same Postgres major version — a version/layout mismatch is a common cause. If versions match, the control file is likely corrupt: investigate storage health and restore from backup. Never edit `pg_control` by hand; `pg_resetwal` is a last resort that can lose data.

## Example

*Illustrative* — a control-file CRC mismatch.

```text
ERROR:  calculated CRC checksum does not match value stored in file
```

## Related

- [invalid data in file](./invalid-data-in-file.md)
- [could not read from file](./could-not-read-from-file.md)
