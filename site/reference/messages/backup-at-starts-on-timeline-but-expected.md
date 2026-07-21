---
message: "backup at \"%s\" starts on timeline %u, but expected %u"
slug: backup-at-starts-on-timeline-but-expected
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:581"
reproduced: false
---

# `backup at "%s" starts on timeline %u, but expected %u`

## What it means

`pg_combinebackup` found that a backup in the chain began on a different timeline than the chain requires. The placeholders are the actual and expected timeline IDs. All backups in a chain must share one timeline lineage.

## When it happens

It occurs when combining backups that were taken across a promotion or point-in-time recovery, which advanced the timeline, so the incrementals no longer form one continuous history.

## How to fix

Combine only backups taken on the same timeline. If the server was promoted or recovered onto a new timeline, take a fresh full backup on that timeline and build a new incremental chain from it.

## Example

*Illustrative* — a timeline mismatch in the chain.

```text
FATAL:  backup at "/backups/inc" starts on timeline 3, but expected 2
```

## Related

- [backup at starts at lsn but expected](./backup-at-starts-at-lsn-but-expected.md)
- [backup label contains data inconsistent with control file](./backup-label-contains-data-inconsistent-with-control-file.md)
