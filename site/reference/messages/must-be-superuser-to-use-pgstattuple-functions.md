---
message: "must be superuser to use pgstattuple functions"
slug: must-be-superuser-to-use-pgstattuple-functions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/contrib/pgstattuple/pgstatapprox.c:284"
  - "postgres/contrib/pgstattuple/pgstatindex.c:150"
  - "postgres/contrib/pgstattuple/pgstatindex.c:192"
  - "postgres/contrib/pgstattuple/pgstatindex.c:420"
  - "postgres/contrib/pgstattuple/pgstatindex.c:452"
  - "postgres/contrib/pgstattuple/pgstatindex.c:508"
  - "postgres/contrib/pgstattuple/pgstattuple.c:176"
  - "postgres/contrib/pgstattuple/pgstattuple.c:216"
reproduced: false
---

# `must be superuser to use pgstattuple functions`

## What it means

A `pgstattuple` function (which scans a table or index to report physical tuple-level statistics) was called by a non-superuser. These functions read raw storage and can be expensive, so they are restricted.

## When it happens

Calling `pgstattuple`, `pgstatindex`, `pgstatginindex`, or `pgstattuple_approx` as a role without superuser rights. It appears during storage/bloat analysis run by an unprivileged role.

## How to fix

Run these functions as a superuser, or have a superuser `GRANT EXECUTE` on the specific functions to a trusted monitoring role (recent versions allow granting execute to non-superusers, and the `pg_stat_scan_tables` role helps for some). Grant narrowly — these functions scan whole relations and expose physical layout.

## Example

*Illustrative* — a non-superuser calling pgstattuple.

```sql
SELECT * FROM pgstattuple('orders');
```

Produces:

```text
ERROR:  must be superuser to use pgstattuple functions
```

## Related

- [must be superuser to use raw page functions](./must-be-superuser-to-use-raw-page-functions.md)
- [cannot access temporary tables of other sessions](./cannot-access-temporary-tables-of-other-sessions.md)
