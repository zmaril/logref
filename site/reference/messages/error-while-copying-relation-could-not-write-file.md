---
message: "error while copying relation \"%s.%s\": could not write file \"%s\": %m"
slug: error-while-copying-relation-could-not-write-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/file.c:118"
reproduced: false
---

# `error while copying relation "%s.%s": could not write file "%s": %m`

## What it means

`pg_upgrade` was copying a relation's data file into the new cluster and the write failed. The placeholders name the relation, the destination file, and the operating-system error.

## When it happens

It fires during the `pg_upgrade` copy phase when the new cluster's target file cannot be written — most often a full destination disk, a permissions problem, or an I/O error on the target volume.

## How to fix

Check the trailing operating-system error. Free space on the volume holding the new data directory, confirm the upgrade user can write there, and verify the target disk is healthy. Re-run `pg_upgrade` once the destination has room and correct ownership; the old cluster is untouched by a failed run.

## Example

*Illustrative* — the destination disk is full.

```
error while copying relation "public.orders": could not write file "/new/base/16400/24576": No space left on device
```

## Related

- [error while copying relation ... could not read file](./error-while-copying-relation-could-not-read-file.md)
- [error while copying relation ... (to)](./error-while-copying-relation-to.md)
