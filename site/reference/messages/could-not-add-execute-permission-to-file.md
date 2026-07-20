---
message: "could not add execute permission to file \"%s\": %m"
slug: could-not-add-execute-permission-to-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/check.c:1001"
reproduced: false
---

# `could not add execute permission to file "%s": %m`

## What it means

`pg_upgrade` could not set execute permission on a file it created (typically a generated script). The file was written but could not be made executable, so the step fails.

## When it happens

It happens during `pg_upgrade` when a `chmod` on a produced script fails, for example due to filesystem permissions or a read-only location.

## How to fix

Ensure the output directory is writable by the user running `pg_upgrade` and is not on a `noexec`/read-only mount. Fix the permissions or choose a different working directory, then rerun.

## Example

*Illustrative* — a failed chmod during pg_upgrade.

```text
pg_upgrade: fatal: could not add execute permission to file "...": Operation not permitted
```

## Related

- [could not change directory to](./could-not-change-directory-to-41f86e.md)
- [could not allocate memory for shared memory name](./could-not-allocate-memory-for-shared-memory-name.md)
