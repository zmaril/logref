---
message: "could not synchronize directory \"%s\": %m"
slug: could-not-synchronize-directory
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/relfilenumber.c:431"
reproduced: false
---

# `could not synchronize directory "%s": %m`

## What it means

`pg_upgrade` could not flush a directory's metadata to disk. The placeholder is the directory and the trailing text is the operating-system error. Synchronizing a directory ensures its entries survive a crash.

## When it happens

It fires during `pg_upgrade`'s file-transfer step, when it fsyncs a directory in the new cluster and the operation fails.

## How to fix

Read the OS error. A permission problem means the user running `pg_upgrade` cannot access the directory; an I/O error points at the storage. Confirm the new cluster's data directory is on healthy, writable storage and rerun. If you are certain durability is not needed for a throwaway run, `pg_upgrade`'s no-sync option skips these flushes.

## Example

*Illustrative* — a directory fsync failed.

```text
pg_upgrade: error: could not synchronize directory "new_cluster/base/1": Input/output error
```

## Related

- [could not synchronize file](./could-not-synchronize-file.md)
- [could not synchronize parent directory of](./could-not-synchronize-parent-directory-of.md)
