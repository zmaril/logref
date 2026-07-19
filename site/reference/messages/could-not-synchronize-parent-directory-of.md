---
message: "could not synchronize parent directory of \"%s\": %m"
slug: could-not-synchronize-parent-directory-of
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/relfilenumber.c:433"
reproduced: false
---

# `could not synchronize parent directory of "%s": %m`

## What it means

`pg_upgrade` could not flush the parent directory of a file to disk. The placeholder is the file whose parent directory was being synchronized, and the trailing text is the operating-system error. Flushing the parent directory makes a newly created file's entry durable.

## When it happens

It fires during `pg_upgrade` after creating a file in the new cluster, when the fsync of the enclosing directory fails.

## How to fix

Read the OS error, which is usually a permission problem or an I/O error on the new cluster's storage. Ensure the directory is writable by the user running `pg_upgrade` and the disk is healthy, then rerun. The no-sync option bypasses these flushes for disposable runs.

## Example

*Illustrative* — a parent-directory fsync failed.

```text
pg_upgrade: error: could not synchronize parent directory of "new_cluster/base/1/1259": Permission denied
```

## Related

- [could not synchronize directory](./could-not-synchronize-directory.md)
- [could not synchronize file](./could-not-synchronize-file.md)
