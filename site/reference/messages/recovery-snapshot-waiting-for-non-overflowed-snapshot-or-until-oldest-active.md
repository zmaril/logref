---
message: "recovery snapshot waiting for non-overflowed snapshot or until oldest active xid on standby is at least %u (now %u)"
slug: recovery-snapshot-waiting-for-non-overflowed-snapshot-or-until-oldest-active
passthrough: false
api: [elog]
level: [DEBUG1]
call_sites:
  - "postgres/src/backend/storage/ipc/procarray.c:1119"
  - "postgres/src/backend/storage/ipc/procarray.c:1297"
reproduced: false
---

# `recovery snapshot waiting for non-overflowed snapshot or until oldest active xid on standby is at least %u (now %u)`

## What it means

During recovery a hot-standby is holding off enabling read queries because it needs a snapshot whose subtransaction state is not overflowed, or it is waiting until the oldest running transaction on the standby reaches a known lower bound.

## When it happens

It is emitted at DEBUG1 while a standby replays WAL and works toward the consistent point where it can safely answer queries. It is normal startup bookkeeping while the running-transactions snapshot is being established.

## Is this a problem?

This is a tracing line, not a fault. It disappears once the standby has a usable snapshot and opens for connections. If a standby never reaches this state, look for a primary that has not emitted a running-xacts record recently, or long-running transactions on the primary.

## Example

*Illustrative* — a standby resolving its initial snapshot during replay.

```text
DEBUG:  recovery snapshot waiting for non-overflowed snapshot or until oldest active xid on standby is at least 5001 (now 4990)
```

## Related

- [recovery snapshots are now enabled](./recovery-snapshots-are-now-enabled.md)
- [recovery stopping after reaching consistency](./recovery-stopping-after-reaching-consistency.md)
