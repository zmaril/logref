---
message: "error while copying relation \"%s.%s\" (\"%s\" to \"%s\"): %m"
slug: error-while-copying-relation-to
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/file.c:132"
reproduced: false
---

# `error while copying relation "%s.%s" ("%s" to "%s"): %m`

## What it means

`pg_upgrade` failed while copying a relation's file from an old-cluster path to a new-cluster path. The placeholders name the relation, the source and destination paths, and the operating-system error.

## When it happens

It fires during the `pg_upgrade` copy transfer mode when the copy of a specific segment file did not complete — for example an I/O error, a missing source file, or no space on the destination.

## How to fix

Read the operating-system error at the end of the line for the cause. Confirm both data directories are intact, that the upgrade user can read the source and write the destination, and that the target volume has free space. Correct the underlying problem and re-run; consider `--link` or `--clone` mode if you want to avoid a full data copy.

## Example

*Illustrative* — the copy of one segment failed.

```
error while copying relation "public.orders" ("/old/base/16384/24576" to "/new/base/16400/24576"): No space left on device
```

## Related

- [error while creating link for relation ... (to)](./error-while-creating-link-for-relation-to.md)
- [error while copying relation ... could not write file](./error-while-copying-relation-could-not-write-file.md)
