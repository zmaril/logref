---
message: "terminating connection due to conflict with recovery"
slug: terminating-connection-due-to-conflict-with-recovery
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_DATABASE_DROPPED
    code: "57P04"
  - symbol: ERRCODE_T_R_SERIALIZATION_FAILURE
    code: "40001"
call_sites:
  - "postgres/src/backend/tcop/postgres.c:3308"
  - "postgres/src/backend/tcop/postgres.c:3394"
reproduced: false
---

# `terminating connection due to conflict with recovery`

## What it means

On a hot-standby replica, the server canceled a session because a query it was running conflicted with the replay of WAL from the primary. To keep applying changes and stay current, recovery wins and the conflicting session is terminated.

## When it happens

It arises on a standby when replay needs to remove or lock data a long-running read query still depends on — for example vacuum cleanup, dropped/truncated relations, or lock conflicts replayed from the primary.

## How to fix

Reduce conflicts by tuning standby feedback and delay: enable `hot_standby_feedback`, or raise `max_standby_streaming_delay`/`max_standby_archive_delay` to give queries more time (at the cost of replay lag). Keep standby queries short, or run heavy reporting against a replica configured to tolerate the delay.

## Example

*Illustrative* — a standby query canceled by recovery.

```text
FATAL:  terminating connection due to conflict with recovery
DETAIL:  User query might have needed to see row versions that must be removed.
```

## Related

- [terminating connection due to unexpected postmaster exit](./terminating-connection-due-to-unexpected-postmaster-exit.md)
- [standby promotion is ongoing](./standby-promotion-is-ongoing.md)
