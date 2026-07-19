---
message: "only heap AM is supported"
slug: only-heap-am-is-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/amcheck/verify_heapam.c:349"
  - "postgres/contrib/pageinspect/heapfuncs.c:330"
  - "postgres/contrib/pg_surgery/heap_surgery.c:119"
  - "postgres/contrib/pgrowlocks/pgrowlocks.c:100"
  - "postgres/contrib/pgstattuple/pgstatapprox.c:349"
  - "postgres/contrib/pgstattuple/pgstattuple.c:333"
  - "postgres/src/backend/access/heap/heapam.c:1447"
reproduced: false
---

# `only heap AM is supported`

## What it means

A function or operation that only works on the built-in `heap` table access method was applied to a table using a different access method. The placeholder situation: low-level tools (`pageinspect`, `pg_surgery`, `pgrowlocks`, `pgstattuple`) understand heap storage and refuse tables stored by another AM.

## When it happens

Calling heap-specific inspection/surgery functions on a table created `USING <other_am>` (a custom table access method), or on an object whose storage is not heap. It appears when third-party storage engines are in use.

## How to fix

Only use these heap-specific functions on heap tables. Check the table's access method with `\d+ name` (or `pg_class.relam`). For non-heap tables, use tools provided by that access method, if any. There is no way to make heap-only functions work on other storage.

## Example

*Illustrative* — a heap-only function on a non-heap table.

```sql
SELECT * FROM pgstattuple('columnar_table');
```

Produces:

```text
ERROR:  only heap AM is supported
```

## Related

- [is not a table](./is-not-a-table.md)
- [cannot access temporary tables of other sessions](./cannot-access-temporary-tables-of-other-sessions.md)
