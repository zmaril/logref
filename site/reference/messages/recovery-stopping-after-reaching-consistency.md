---
message: "recovery stopping after reaching consistency"
slug: recovery-stopping-after-reaching-consistency
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/access/transam/xlogrecovery.c:2568"
  - "postgres/src/backend/access/transam/xlogrecovery.c:2844"
reproduced: false
---

# `recovery stopping after reaching consistency`

## What it means

Recovery halted at the point where the database first became internally consistent, because the recovery target was set to that point rather than a later time, LSN, or transaction id.

## When it happens

It appears when `recovery_target = 'immediate'` is configured: the server replays only as far as it needs to reach consistency, then stops and does not continue applying later WAL.

## Is this a problem?

If stopping at the earliest consistent point is what you intended, this is expected. If you needed to recover further, change `recovery_target` (or use `recovery_target_time`/`recovery_target_lsn`) and restart recovery from the base backup.

## Example

*Illustrative* — recovery configured to stop as soon as it is consistent.

```text
LOG:  recovery stopping after reaching consistency
```

## Related

- [recovery snapshots are now enabled](./recovery-snapshots-are-now-enabled.md)
- [WAL contains references to invalid pages](./wal-contains-references-to-invalid-pages.md)
