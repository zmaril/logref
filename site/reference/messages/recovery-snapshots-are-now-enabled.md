---
message: "recovery snapshots are now enabled"
slug: recovery-snapshots-are-now-enabled
passthrough: false
api: [elog]
level: [DEBUG1]
call_sites:
  - "postgres/src/backend/storage/ipc/procarray.c:1115"
  - "postgres/src/backend/storage/ipc/procarray.c:1295"
reproduced: false
---

# `recovery snapshots are now enabled`

## What it means

A hot-standby has reached the point in WAL replay where it has a valid transaction snapshot, so it can now serve read-only queries.

## When it happens

It is logged at DEBUG1 once, when the standby transitions from replay-only to accepting queries — the counterpart of the earlier waiting message.

## Is this a problem?

This is a positive milestone, not a problem. It confirms the standby is now queryable. No action is needed.

## Example

*Illustrative* — a standby opening for read queries.

```text
DEBUG:  recovery snapshots are now enabled
```

## Related

- [recovery snapshot waiting for non-overflowed snapshot](./recovery-snapshot-waiting-for-non-overflowed-snapshot-or-until-oldest-active.md)
- [recovery stopping after reaching consistency](./recovery-stopping-after-reaching-consistency.md)
