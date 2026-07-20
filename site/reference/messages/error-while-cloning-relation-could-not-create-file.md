---
message: "error while cloning relation \"%s.%s\": could not create file \"%s\": %m"
slug: error-while-cloning-relation-could-not-create-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/file.c:52"
reproduced: false
---

# `error while cloning relation "%s.%s": could not create file "%s": %m`

## What it means

During `pg_upgrade` in clone mode, cloning a relation failed because the destination data file could not be created. The placeholders are the schema-qualified relation, the file name, and the OS error.

## When it happens

It fires in `pg_upgrade` while cloning relation files into the new cluster, when creating the target file fails — a permission problem, a missing directory, or a full disk.

## How to fix

Read the OS error. Confirm the new data directory is writable by the `pg_upgrade` user and has free space, and that the target tablespace directories exist. Fix the filesystem issue and rerun `pg_upgrade`.

## Example

*Illustrative* — a file-create failure while cloning.

```text
pg_upgrade: error: error while cloning relation "public.t": could not create file "/new/...": Permission denied
```

## Related

- [error while cloning relation could not open file](./error-while-cloning-relation-could-not-open-file.md)
- [error while cloning relation to](./error-while-cloning-relation-to-87b802.md)
