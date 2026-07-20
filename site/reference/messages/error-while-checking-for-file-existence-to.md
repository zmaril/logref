---
message: "error while checking for file existence \"%s.%s\" (\"%s\" to \"%s\"): %m"
slug: error-while-checking-for-file-existence-to
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/relfilenumber.c:576"
reproduced: false
---

# `error while checking for file existence "%s.%s" ("%s" to "%s"): %m`

## What it means

During `pg_upgrade`, checking whether a relation's data file exists failed with an operating-system error. The placeholders are the file name parts, the source and target paths, and the OS error. A `stat`-style check on a file could not complete.

## When it happens

It fires in `pg_upgrade` while transferring relation files (link/clone/copy mode), when testing for a file's presence hits an OS error such as a permission problem or an unreadable path.

## How to fix

Read the OS error. Confirm the old and new data directories are readable by the user running `pg_upgrade`, the paths exist, and the filesystem is healthy. Fix permissions or the path problem and rerun `pg_upgrade`.

## Example

*Illustrative* — a file-existence check failing.

```text
pg_upgrade: error: error while checking for file existence "base.1259" ("/old/..." to "/new/..."): Permission denied
```

## Related

- [error while cloning relation could not open file](./error-while-cloning-relation-could-not-open-file.md)
- [error while copying relation: could not copy file range from to](./error-while-copying-relation-could-not-copy-file-range-from-to.md)
