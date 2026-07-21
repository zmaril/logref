---
message: "could not find just referenced shared stats entry"
slug: could-not-find-just-referenced-shared-stats-entry
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/activity/pgstat_shmem.c:654"
reproduced: false
---

# `could not find just referenced shared stats entry`

## What it means

The cumulative-statistics system referenced a shared stats entry and then could not find it moments later. This is an internal consistency check in the shared-memory statistics machinery.

## When it happens

It fires during statistics reporting or reading when an entry that was just referenced disappears from the shared hash. Reaching it points at an internal accounting or shared-memory problem.

## How to fix

This is an internal error. If it recurs, note the workload and any extensions that report custom statistics, and report a reproducible case with the surrounding log.

## Example

*Illustrative* — a shared stats entry vanishing after reference.

```text
ERROR:  could not find just referenced shared stats entry
```

## Related

- [could not find a free IO worker slot](./could-not-find-a-free-io-worker-slot.md)
- [could not find entry in sinval array](./could-not-find-entry-in-sinval-array.md)
