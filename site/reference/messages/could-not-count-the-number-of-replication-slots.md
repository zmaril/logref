---
message: "could not count the number of replication slots"
slug: could-not-count-the-number-of-replication-slots
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/check.c:2094"
reproduced: false
---

# `could not count the number of replication slots`

## What it means

`pg_upgrade` could not read how many replication slots the old cluster has while checking upgrade prerequisites. The query it ran did not return a usable count.

## When it happens

It happens during `pg_upgrade`'s pre-check phase when querying the old cluster's replication-slot catalog fails, usually because the old server is not responding as expected.

## How to fix

Confirm the old cluster starts and answers queries on its own, and that the connection `pg_upgrade` uses has the needed privileges. Resolve any old-server startup problem, then rerun `pg_upgrade`.

## Example

*Illustrative* — the slot count query failing during upgrade checks.

```text
could not count the number of replication slots
```

## Related

- [could not determine the number of users](./could-not-determine-the-number-of-users.md)
- [could not connect to source postmaster started with the command](./could-not-connect-to-source-postmaster-started-with-the-command.md)
