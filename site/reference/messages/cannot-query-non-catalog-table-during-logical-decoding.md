---
message: "cannot query non-catalog table \"%s\" during logical decoding"
slug: cannot-query-non-catalog-table-during-logical-decoding
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:1219"
  - "postgres/src/backend/access/index/indexam.c:272"
reproduced: false
---

# `cannot query non-catalog table "%s" during logical decoding`

## What it means

Output-plugin or decoding code tried to read an ordinary user table while logical decoding is running. The placeholder is the table name. Logical decoding may only read catalog tables, because user-table state at the historic decoding point is not available.

## When it happens

A logical-decoding output plugin (or a function it calls) that scans a regular user table during the decode of a change, rather than restricting itself to catalog lookups.

## How to fix

In output plugins, read only system catalogs during decoding; do not query user tables. If custom decoding logic needs user data, capture it into the change stream itself or look it up outside the decoding context. Report the plugin if it is third-party.

## Example

*Illustrative* — a plugin scanning a user table while decoding.

```text
ERROR:  cannot query non-catalog table "orders" during logical decoding
```

## Related

- [cannot open relation](./cannot-open-relation.md)
- [could not find record for logical decoding](./could-not-find-record-for-logical-decoding.md)
