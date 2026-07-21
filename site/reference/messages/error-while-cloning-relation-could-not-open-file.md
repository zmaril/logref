---
message: "error while cloning relation \"%s.%s\": could not open file \"%s\": %m"
slug: error-while-cloning-relation-could-not-open-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/file.c:47"
reproduced: false
---

# `error while cloning relation "%s.%s": could not open file "%s": %m`

## What it means

During `pg_upgrade` in clone mode, cloning a relation failed because the source data file could not be opened. The placeholders are the schema-qualified relation, the file name, and the OS error.

## When it happens

It fires in `pg_upgrade` while cloning relation files, when opening the source file in the old cluster fails — a permission problem, a missing file, or an I/O error.

## How to fix

Read the OS error. Confirm the old data directory is readable by the `pg_upgrade` user and intact, and that the old cluster was shut down cleanly. Fix the access or storage issue and rerun.

## Example

*Illustrative* — a file-open failure while cloning.

```text
pg_upgrade: error: error while cloning relation "public.t": could not open file "/old/...": No such file or directory
```

## Related

- [error while cloning relation could not create file](./error-while-cloning-relation-could-not-create-file.md)
- [error while checking for file existence to](./error-while-checking-for-file-existence-to.md)
