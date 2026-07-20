---
message: "could not clone file between old and new data directories: %m"
slug: could-not-clone-file-between-old-and-new-data-directories
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/file.c:207"
  - "postgres/src/bin/pg_upgrade/file.c:223"
reproduced: false
---

# `could not clone file between old and new data directories: %m`

## What it means

During `pg_upgrade` in clone mode, the OS-level file clone between the old and new data directories failed. The placeholder is the system reason. Clone mode relies on a filesystem that supports reflink-style copies, and the operation did not succeed.

## When it happens

Running `pg_upgrade --clone` when the old and new data directories are on different filesystems, on a filesystem that does not support cloning, or when a filesystem or permission error interrupts the clone.

## How to fix

Ensure the old and new data directories are on the same filesystem and that it supports file cloning (for example XFS with reflink, or Btrfs/ZFS/APFS). Otherwise run `pg_upgrade` without `--clone` (use copy or link mode). Address the specific OS error in the detail before retrying.

## Example

*Illustrative* — a failed clone during upgrade.

```text
FATAL:  could not clone file between old and new data directories: Operation not supported
```

## Related

- [could not clone file to](./could-not-clone-file-to.md)
- [could not determine parameter settings on new cluster](./could-not-determine-parameter-settings-on-new-cluster.md)
