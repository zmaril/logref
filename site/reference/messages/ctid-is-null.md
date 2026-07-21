---
message: "ctid is NULL"
slug: ctid-is-null
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:4358"
  - "postgres/src/backend/executor/nodeLockRows.c:122"
  - "postgres/src/backend/executor/nodeModifyTable.c:4885"
reproduced: false
---

# `ctid is NULL`

## What it means

Internal error. Code (here `postgres_fdw`) expected a row's `ctid` — the physical row identifier used to locate a tuple for update or delete — to be present, but it was NULL. The placeholder-free message is a consistency check on the row-identity column an update path relies on.

## When it happens

It does not arise from ordinary SQL. With `postgres_fdw` it points to an update/delete plan that did not carry the remote row identifier as expected, or an FDW interaction bug, rather than to user data.

## How to fix

Treat it as an internal/FDW bug. Ensure the foreign table and the operation support the row-identity mechanism the FDW needs (a suitable key/`ctid` projection). Capture the statement and plan and report it; if a custom FDW is involved, suspect its row-identity handling.

## Example

*Illustrative* — a missing row identifier in an FDW update.

```text
ERROR:  ctid is NULL
```

## Related

- [could not find junk column](./could-not-find-junk-column.md)
- [failed to fetch tuple being updated](./failed-to-fetch-tuple-being-updated.md)
