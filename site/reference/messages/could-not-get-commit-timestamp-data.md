---
message: "could not get commit timestamp data"
slug: could-not-get-commit-timestamp-data
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/access/transam/commit_ts.c:392"
reproduced: false
---

# `could not get commit timestamp data`

## What it means

A query asked for the commit timestamp of a transaction, but commit-timestamp tracking is not providing that data. Postgres can record when each transaction committed, and this feature must be enabled for the lookup to work.

## When it happens

It happens when calling `pg_xact_commit_timestamp` or related functions while `track_commit_timestamp` is off, or for a transaction older than the retained history.

## How to fix

Enable commit-timestamp tracking by setting `track_commit_timestamp = on` in `postgresql.conf` and restarting the server. Note that only transactions committing after it is enabled have timestamps; timestamps for transactions committed while it was off are not available retroactively.

## Example

*Illustrative* — asking for a commit timestamp with tracking off.

```sql
SELECT pg_xact_commit_timestamp('1234'::xid);
-- ERROR:  could not get commit timestamp data
-- HINT:  Make sure the configuration parameter "track_commit_timestamp" is set.
```

## Related

- [could not get system identifier](./could-not-get-system-identifier.md)
- [could not get server version](./could-not-get-server-version.md)
