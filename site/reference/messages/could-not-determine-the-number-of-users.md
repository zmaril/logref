---
message: "could not determine the number of users"
slug: could-not-determine-the-number-of-users
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/check.c:1048"
reproduced: false
---

# `could not determine the number of users`

## What it means

`pg_upgrade` could not read how many roles the old cluster has while running its pre-upgrade checks. The query it used did not return a usable count.

## When it happens

It happens during `pg_upgrade`'s check phase when querying the old cluster's role catalog fails, usually because the old server is not responding as expected.

## How to fix

Confirm the old cluster starts and answers queries on its own and that the connection `pg_upgrade` uses has the needed privileges. Resolve any old-server startup problem, then rerun `pg_upgrade`.

## Example

*Illustrative* — the role-count query failing during upgrade checks.

```text
could not determine the number of users
```

## Related

- [could not count the number of replication slots](./could-not-count-the-number-of-replication-slots.md)
- [could not connect to source postmaster started with the command](./could-not-connect-to-source-postmaster-started-with-the-command.md)
