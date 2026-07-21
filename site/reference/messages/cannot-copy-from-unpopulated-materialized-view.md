---
message: "cannot copy from unpopulated materialized view \"%s\""
slug: cannot-copy-from-unpopulated-materialized-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copyto.c:823"
reproduced: false
---

# `cannot copy from unpopulated materialized view "%s"`

## What it means

A `COPY ... TO` named a materialized view that has not been populated. An unpopulated materialized view holds no data yet, so there is nothing for `COPY` to read. The placeholder is the view name.

## When it happens

It occurs when copying from a materialized view created `WITH NO DATA` and not yet refreshed.

## How to fix

Run `REFRESH MATERIALIZED VIEW` to populate it, then copy. A materialized view has no contents until it has been refreshed at least once.

## Example

*Illustrative* — COPY from an unpopulated matview.

```text
ERROR:  cannot copy from unpopulated materialized view "mv"
```

## Related

- [cannot copy to materialized view](./cannot-copy-to-materialized-view.md)
- [cannot copy from view](./cannot-copy-from-view.md)
