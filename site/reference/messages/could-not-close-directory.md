---
message: "could not close directory \"%s\": %m"
slug: could-not-close-directory
passthrough: false
api: [pg_fatal, pg_log_warning]
level: [FATAL, WARNING]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:256"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:1333"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1000"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1041"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1079"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1116"
  - "postgres/src/bin/pg_rewind/file_ops.c:489"
  - "postgres/src/common/pgfnames.c:73"
reproduced: false
---

# `could not close directory "%s": %m`

## What it means

Closing a directory handle (`closedir()`) failed. The path is the first placeholder and `%m` the OS error. This is uncommon and usually surfaces a deeper filesystem problem, since `closedir` rarely fails on healthy storage.

## When it happens

After scanning a directory (data directory, tablespace, backup source) in the server or a client tool. A failing `closedir` typically indicates failing storage or a network-filesystem problem (`Stale file handle`, `Input/output error`).

## How to fix

Read `%m`. It almost always points at unhealthy storage or an unstable mount — check kernel logs, disk health, and the network filesystem if one is involved. The close failure itself is minor, but the underlying condition may affect other operations, so investigate the storage.

## Example

*Illustrative* — a directory close on a stale NFS handle.

```text
WARNING:  could not close directory "/mnt/nfs/pg": Stale file handle
```

## Related

- [could not open directory](./could-not-open-directory.md)
- [could not read directory](./could-not-read-directory.md)
