---
message: "expected start timeline %u but found timeline %u"
slug: expected-start-timeline-but-found-timeline
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/backup/backup_manifest.c:278"
reproduced: false
---

# `expected start timeline %u but found timeline %u`

## What it means

While verifying a backup manifest, the server found a WAL range whose starting timeline did not match what the manifest expected. The placeholders are the expected and actual timeline numbers.

## When it happens

It fires during backup or manifest verification when the WAL's starting timeline does not line up with the manifest's recorded ranges — typically because WAL from a different timeline was mixed into the backup set.

## How to fix

Ensure the backup and its WAL segments all come from the same cluster and timeline lineage. Do not combine WAL from different timelines. Re-take the base backup if the WAL set is inconsistent, then re-verify.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected start timeline 2 but found timeline 3
```

## Related

- [expected end timeline but found timeline](./expected-end-timeline-but-found-timeline.md)
- [Expected a numeric timeline ID.](./expected-a-numeric-timeline-id.md)
