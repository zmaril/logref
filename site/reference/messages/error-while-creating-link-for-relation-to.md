---
message: "error while creating link for relation \"%s.%s\" (\"%s\" to \"%s\"): %m"
slug: error-while-creating-link-for-relation-to
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/file.c:190"
reproduced: false
---

# `error while creating link for relation "%s.%s" ("%s" to "%s"): %m`

## What it means

`pg_upgrade` was running in `--link` mode and failed to create a hard link from an old-cluster data file to the new cluster. The placeholders name the relation, the source and destination paths, and the operating-system error.

## When it happens

It fires during a link-mode upgrade when the hard link could not be created — commonly because the old and new data directories live on different filesystems (hard links cannot cross mount points), or because of a permissions or I/O error.

## How to fix

Hard links require both data directories on the same filesystem. If they are on separate mounts, move the new data directory onto the same volume, or use the default copy mode or `--clone` instead. Otherwise read the operating-system error for permissions or disk problems, correct it, and re-run.

## Example

*Illustrative* — the two clusters are on different filesystems.

```
error while creating link for relation "public.orders" ("/old/base/16384/24576" to "/mnt/new/base/16400/24576"): Invalid cross-device link
```

## Related

- [error while copying relation ... (to)](./error-while-copying-relation-to.md)
- [error while copying relation ... could not read file](./error-while-copying-relation-could-not-read-file.md)
