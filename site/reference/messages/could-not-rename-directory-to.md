---
message: "could not rename directory \"%s\" to \"%s\": %m"
slug: could-not-rename-directory-to
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/relfilenumber.c:293"
  - "postgres/src/bin/pg_upgrade/relfilenumber.c:297"
reproduced: false
---

# `could not rename directory "%s" to "%s": %m`

## What it means

`pg_upgrade` could not rename a directory during relfilenode swapping. The two `%s` values are the source and destination paths and the `%m` is the operating-system error. The upgrade step could not complete.

## When it happens

A permission problem, a cross-filesystem move, or a leftover destination directory blocked the rename while `pg_upgrade` relinked or moved storage.

## How to fix

Read the trailing error. Ensure the old and new data directories are on the same filesystem for link mode, that the upgrade user owns them, and that no stale destination exists. Re-run the upgrade after fixing.

## Example

*Illustrative* — a rename blocked by permissions.

```text
could not rename directory "/new/base/16384" to "/new/base/16384.old": Permission denied
```

## Related

- [could not set permissions on directory](./could-not-set-permissions-on-directory.md)
- [error while copying relation: could not create file](./error-while-copying-relation-could-not-create-file.md)
