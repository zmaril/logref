---
message: "could not get system identifier: %s"
slug: could-not-get-system-identifier
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:654"
reproduced: false
---

# `could not get system identifier: %s`

## What it means

`pg_createsubscriber` queried a cluster for its system identifier — the unique number stamped into every cluster at `initdb` — and the query failed. The `%s` value gives the reason. It compares identifiers to make sure it is wiring up the right pair.

## When it happens

It happens while setting up a logical-replication subscriber from a physical standby, when the identifier query against the target or source fails — often a connection or permissions problem.

## How to fix

Confirm the connection strings and credentials `pg_createsubscriber` was given reach the intended clusters and can run the identifier query, then rerun. The included reason usually points at the connection or permission cause.

## Example

*Illustrative* — the system identifier query failed.

```text
pg_createsubscriber: error: could not get system identifier: connection to server failed
```

## Related

- [could not get system identifier: got rows, expected row](./could-not-get-system-identifier-got-rows-expected-row.md)
- [could not get server version](./could-not-get-server-version.md)
