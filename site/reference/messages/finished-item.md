---
message: "finished item %d %s %s"
slug: finished-item
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:2573"
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:4850"
reproduced: false
---

# `finished item %d %s %s`

## What it means

An informational `pg_restore` progress line reporting that it finished processing a table-of-contents item, identified by its number and description.

## When it happens

It arises during a verbose `pg_restore` as each archive item (a table, index, constraint, and so on) completes.

## Is this a problem?

No action is needed. It is restore-progress output. It is useful for tracking how far a restore has advanced.

## Example

*Illustrative* — a restore item finishing.

```text
INFO:  finished item 42 TABLE DATA orders
```

## Related

- [executing %s](./executing-ddcf88.md)
- [archive items not in correct section order](./archive-items-not-in-correct-section-order.md)
