---
message: "according to history file, WAL location %X/%08X belongs to timeline %u, but previous recovered WAL file came from timeline %u"
slug: according-to-history-file-wal-location-belongs-to-timeline-but-previous
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/xlogrecovery.c:3858"
reproduced: false
---

# `according to history file, WAL location %X/%08X belongs to timeline %u, but previous recovered WAL file came from timeline %u`

## What it means

During recovery the timeline history file says a given WAL location belongs to one timeline, but the WAL file actually recovered at that point came from a different timeline, so the history and the WAL disagree.

## When it happens

It is raised when following a recovery target across timelines and the archived history file is inconsistent with the WAL segments present — for example mismatched or incomplete archives after a promotion.

## How to fix

Make sure the timeline history files and WAL segments in your archive are complete and consistent with the base backup you are recovering. Verify `recovery_target_timeline`, re-fetch missing history/WAL from the archive, and recover from a coherent backup set. A gap or mismatch in archived timelines is the usual cause.

## Example

*Illustrative* — history file and recovered WAL disagreeing on timeline.

```text
ERROR:  according to history file, WAL location 0/3000000 belongs to timeline 3, but previous recovered WAL file came from timeline 2
```

## Related

- [WAL contains references to invalid pages](./wal-contains-references-to-invalid-pages.md)
- [archives must precede manifest](./archives-must-precede-manifest.md)
