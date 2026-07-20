---
message: "archive items not in correct section order"
slug: archive-items-not-in-correct-section-order
passthrough: false
api: [pg_log_warning]
level: [WARNING]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:316"
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:320"
reproduced: false
---

# `archive items not in correct section order`

## What it means

A warning from `pg_restore` that the archive's table-of-contents entries are not in the expected section order (pre-data, data, post-data) it uses to schedule the restore.

## When it happens

It arises when restoring an archive whose entries were reordered or produced by a tool version with different ordering assumptions. `pg_restore` still proceeds, but flags the anomaly.

## Is this a problem?

Usually no action is needed — the restore continues. If the restore later fails on ordering, regenerate the dump with a matching `pg_dump` version, or restore with explicit `--section` passes so each section is applied in order.

## Example

*Illustrative* — an out-of-order archive TOC.

```text
WARNING:  archive items not in correct section order
```

## Related

- [unrecognized dependency type '%c' for %s](./unrecognized-dependency-type-for.md)
- [finished item %d %s %s](./finished-item.md)
