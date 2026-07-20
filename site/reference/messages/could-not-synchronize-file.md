---
message: "could not synchronize file \"%s\": %m"
slug: could-not-synchronize-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/relfilenumber.c:68"
reproduced: false
---

# `could not synchronize file "%s": %m`

## What it means

`pg_upgrade` could not flush a file's contents to disk. The placeholder is the file and the trailing text is the operating-system error. Synchronizing the file ensures its data is durable before the upgrade proceeds.

## When it happens

It fires during `pg_upgrade`'s file transfer when it fsyncs a relation file in the new cluster and the operation fails.

## How to fix

Read the OS error. A permission problem or an I/O error on the new cluster's storage is the usual cause. Confirm the target is writable and the disk is healthy, then rerun. The no-sync option skips these flushes for throwaway upgrades where durability is not a concern.

## Example

*Illustrative* — a file fsync failed.

```text
pg_upgrade: error: could not synchronize file "new_cluster/base/1/1259": Input/output error
```

## Related

- [could not synchronize directory](./could-not-synchronize-directory.md)
- [could not synchronize parent directory of](./could-not-synchronize-parent-directory-of.md)
