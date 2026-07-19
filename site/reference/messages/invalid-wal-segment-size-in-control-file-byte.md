---
message: "invalid WAL segment size in control file (%d byte)"
slug: invalid-wal-segment-size-in-control-file-byte
passthrough: false
api: [ereport, pg_log_error, pg_log_warning]
level: [ERROR, WARNING]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:4597"
  - "postgres/src/bin/pg_controldata/pg_controldata.c:189"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:1050"
reproduced: false
---

# `invalid WAL segment size in control file (%d byte)`

## What it means

The WAL segment size recorded in the cluster's control file is not a valid value. The segment size must be a power of two within a supported range, and the value read from the control file is not.

## When it happens

Starting the server or running a control-file inspection tool against a data directory whose `pg_control` holds a corrupt or unreadable segment-size field. It typically signals control-file damage or a mismatched or truncated data directory.

## How to fix

Treat it as a control-file integrity problem. Verify the data directory is intact and was not partially copied, check storage health, and restore `pg_control` from a consistent backup if it is corrupt. A control file written by an incompatible build can also produce it, so confirm the server version matches the cluster.

## Example

*Illustrative* — a corrupt segment-size field.

```text
ERROR:  invalid WAL segment size in control file (3 byte)
```

## Related

- [control file appears to be corrupt](./control-file-appears-to-be-corrupt-9f0666.md)
- [calculated crc checksum does not match value stored in control file](./calculated-crc-checksum-does-not-match-value-stored-in-control-file.md)
