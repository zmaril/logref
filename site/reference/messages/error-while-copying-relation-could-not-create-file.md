---
message: "error while copying relation \"%s.%s\": could not create file \"%s\": %m"
slug: error-while-copying-relation-could-not-create-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/file.c:92"
  - "postgres/src/bin/pg_upgrade/file.c:161"
reproduced: false
---

# `error while copying relation "%s.%s": could not create file "%s": %m`

## What it means

`pg_upgrade` could not create the destination file while copying (or linking) a relation into the new cluster. The `%s` values are the relation and target file and the `%m` is the operating-system error.

## When it happens

The new cluster's directory was not writable, out of space, or on a different filesystem for link mode, while `pg_upgrade` transferred relation storage.

## How to fix

Read the trailing error. Ensure the new data directory is writable with free space, and for link mode that old and new clusters share a filesystem. Fix the target and rerun the upgrade.

## Example

*Illustrative* — the destination relation file could not be created.

```text
error while copying relation "public.t": could not create file "/new/base/16384/16390": No space left on device
```

## Related

- [error while copying relation: could not open file](./error-while-copying-relation-could-not-open-file.md)
- [could not rename directory to](./could-not-rename-directory-to.md)
