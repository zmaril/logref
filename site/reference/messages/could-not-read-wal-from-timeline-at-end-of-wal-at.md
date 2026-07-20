---
message: "could not read WAL from timeline %u at %X/%08X: end of WAL at %X/%08X"
slug: could-not-read-wal-from-timeline-at-end-of-wal-at
passthrough: false
api: [ereport]
level: [DEBUG1]
call_sites:
  - "postgres/src/backend/postmaster/walsummarizer.c:980"
  - "postgres/src/backend/postmaster/walsummarizer.c:1039"
reproduced: false
---

# `could not read WAL from timeline %u at %X/%08X: end of WAL at %X/%08X`

## What it means

A debug trace line reporting that WAL reading reached the end of available WAL on a timeline at a given position — the reader has caught up, not failed.

## When it happens

It appears at high debug levels during recovery or streaming when the reader hits the current end of WAL on a timeline before more is available.

## Is this a problem?

No action is needed. Reaching the end of available WAL is normal during recovery and streaming; the reader waits for or switches to more WAL. The message is visible only at raised debug levels.

## Example

*Illustrative* — reaching the end of WAL on a timeline.

```text
DEBUG:  could not read WAL from timeline 1 at 0/3000000: end of WAL at 0/3000000
```

## Related

- [checkpoint record is at %X/%08X](./checkpoint-record-is-at.md)
- [recovery has paused](./recovery-has-paused.md)
