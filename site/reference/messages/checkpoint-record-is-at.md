---
message: "checkpoint record is at %X/%08X"
slug: checkpoint-record-is-at
passthrough: false
api: [ereport]
level: [DEBUG1]
call_sites:
  - "postgres/src/backend/access/transam/xlogrecovery.c:577"
  - "postgres/src/backend/access/transam/xlogrecovery.c:727"
reproduced: true
---

# `checkpoint record is at %X/%08X`

## What it means

A debug trace line reporting the WAL location of the checkpoint record the server is working from during startup or recovery.

## When it happens

It appears at high debug levels during startup, recovery, or checkpoint processing. It is diagnostic detail about WAL positions, not a condition to act on.

## Is this a problem?

No action is needed. It is recovery-diagnostics output visible only at raised debug levels. Lower the log level to silence it.

## Example

*Reproduced* — captured by `reproducers/env-run.sh` (scenario `tier4__replication_standby`). The site emits a background log record; the captured line was:

```text
DEBUG:  checkpoint record is at 0/03000088
```

## Related

- [could not read WAL from timeline %u at %X/%08X: end of WAL at %X/%08X](./could-not-read-wal-from-timeline-at-end-of-wal-at.md)
- [recovery has paused](./recovery-has-paused.md)
