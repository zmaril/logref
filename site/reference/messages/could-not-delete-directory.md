---
message: "could not delete directory \"%s\""
slug: could-not-delete-directory
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/pg_upgrade.c:733"
reproduced: false
---

# `could not delete directory "%s"`

## What it means

`pg_upgrade` could not remove a directory it needed to clean up. The `%s` in the context names the directory. Cleanup of a leftover or intermediate directory failed.

## When it happens

It happens during `pg_upgrade` cleanup when removing a directory fails — a permissions problem, files still open in it, or an I/O error.

## How to fix

Check permissions on the directory and make sure no process is holding files open inside it. Remove any leftover directory by hand once the upgrade finishes, after confirming it is safe to delete.

## Example

*Illustrative* — a directory that cannot be removed.

```text
could not delete directory "delete_old_cluster"
```

## Related

- [could not delete fileset](./could-not-delete-fileset.md)
- [could not decide what to do with file](./could-not-decide-what-to-do-with-file.md)
