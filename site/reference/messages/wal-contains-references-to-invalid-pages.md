---
message: "WAL contains references to invalid pages"
slug: wal-contains-references-to-invalid-pages
passthrough: false
api: [elog]
level: [varies]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/access/transam/xlogutils.c:119"
  - "postgres/src/backend/access/transam/xlogutils.c:257"
reproduced: false
---

# `WAL contains references to invalid pages`

## What it means

Replay found WAL records that touch pages the server previously recorded as invalid (missing or truncated away), which normally means either legitimate mid-recovery bookkeeping or genuine corruption depending on when it appears.

## When it happens

It surfaces during recovery. Before consistency is reached it can be a benign artifact of replaying changes to relations that were later dropped or truncated; after consistency, it indicates a real problem with the WAL or the base backup.

## Is this a problem?

The severity depends on context. During early replay it is often resolved as recovery continues. If the server panics or reports this after reaching consistency, treat it as corruption: check hardware and storage, verify the base backup and archived WAL are intact and complete, and recover from a known-good backup if the invalid-page references persist.

## Example

*Illustrative* — invalid page references seen during replay.

```text
PANIC:  WAL contains references to invalid pages
```

## Related

- [recovery stopping after reaching consistency](./recovery-stopping-after-reaching-consistency.md)
- [according to history file, WAL location belongs to timeline](./according-to-history-file-wal-location-belongs-to-timeline-but-previous.md)
