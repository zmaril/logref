---
message: "expected end timeline %u but found timeline %u"
slug: expected-end-timeline-but-found-timeline
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/backup/backup_manifest.c:254"
reproduced: false
---

# `expected end timeline %u but found timeline %u`

## What it means

While verifying a backup manifest, the server found a WAL range whose ending timeline did not match what the manifest expected. The placeholders are the expected and actual timeline numbers.

## When it happens

It fires during backup or manifest verification (for example `pg_verifybackup`, or manifest handling during a base backup) when the timeline information in the WAL does not line up with the manifest's recorded ranges.

## How to fix

Confirm the backup and its WAL come from the same cluster and lineage and were not mixed with files from another timeline. Re-take the base backup if the WAL set is inconsistent. A mismatch usually means WAL files from a different timeline were combined with this backup.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected end timeline 3 but found timeline 4
```

## Related

- [expected start timeline but found timeline](./expected-start-timeline-but-found-timeline.md)
- [Expected a write-ahead log switchpoint location.](./expected-a-write-ahead-log-switchpoint-location.md)
