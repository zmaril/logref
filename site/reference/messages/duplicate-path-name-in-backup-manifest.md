---
message: "duplicate path name in backup manifest: \"%s\""
slug: duplicate-path-name-in-backup-manifest
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/load_manifest.c:280"
reproduced: false
---

# `duplicate path name in backup manifest: "%s"`

## What it means

`pg_combinebackup` read a backup manifest that lists the same file path twice. The placeholder is the path. A manifest must name each file once, so the duplicate makes it invalid.

## When it happens

It fires in `pg_combinebackup` while loading a backup's manifest, when a path appears more than once — usually a damaged or hand-edited manifest.

## How to fix

The backup manifest is corrupt or was altered. Use an intact backup — retake the base or incremental backup that produced this manifest. Do not edit `backup_manifest` by hand.

## Example

*Illustrative* — a duplicated path in a manifest.

```text
pg_combinebackup: error: duplicate path name in backup manifest: "base/1/1259"
```

## Related

- [error while cloning file to](./error-while-cloning-file-to-503a98.md)
- [end block out of bounds](./end-block-out-of-bounds.md)
