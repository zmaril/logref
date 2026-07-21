---
message: "cannot access temporary indexes of other sessions"
slug: cannot-access-temporary-indexes-of-other-sessions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/pgstattuple/pgstatindex.c:556"
  - "postgres/contrib/pgstattuple/pgstatindex.c:646"
  - "postgres/src/backend/access/gin/ginfast.c:1057"
reproduced: false
---

# `cannot access temporary indexes of other sessions`

## What it means

A function tried to read an index on another session's temporary table. Temporary tables and their indexes live in per-session buffers that are not shared, so one backend cannot access another session's temp objects — including inspection functions like those in `pgstattuple`.

## When it happens

Calling an index-inspection or statistics function (for example `pgstatindex`) on a temporary index that belongs to a different session, typically because a temp object's name or OID was reached from outside its owning session.

## How to fix

Run the operation in the session that owns the temporary index, or use a permanent table if you need cross-session access. Temporary objects are intentionally private to their session; there is no way to inspect another session's temp index from outside it.

## Example

*Illustrative* — inspecting another session's temp index.

```text
ERROR:  cannot access temporary indexes of other sessions
```

## Related

- [must be superuser to use pageinspect functions](./must-be-superuser-to-use-pageinspect-functions.md)
- [cannot reindex system catalogs concurrently](./cannot-reindex-system-catalogs-concurrently.md)
