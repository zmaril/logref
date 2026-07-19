---
message: "could not detect conflict as the leader apply worker has exited"
slug: could-not-detect-conflict-as-the-leader-apply-worker-has-exited
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/logical/worker.c:3338"
reproduced: false
---

# `could not detect conflict as the leader apply worker has exited`

## What it means

A logical-replication parallel apply worker tried to check for an update or delete conflict but could not, because the leader apply worker it depends on had already exited. The conflict check could not complete.

## When it happens

It happens during parallel-streaming logical replication when the leader apply worker stops (an error or shutdown) while a parallel worker is still applying, so the shared conflict-detection state is gone.

## How to fix

This is a transient condition tied to the apply worker restarting. Check the subscriber log for why the leader apply worker exited and address that root cause; replication resumes when the workers restart. Disabling parallel apply (`ALTER SUBSCRIPTION ... SET (streaming = on)` without parallel) avoids it if it recurs.

## Example

*Illustrative* — a parallel worker losing its leader mid-apply.

```text
ERROR:  could not detect conflict as the leader apply worker has exited
```

## Related

- [could not connect to publisher when attempting to drop replication slot](./could-not-connect-to-publisher-when-attempting-to-drop-replication-slot.md)
- [could not create replication slot](./could-not-create-replication-slot.md)
