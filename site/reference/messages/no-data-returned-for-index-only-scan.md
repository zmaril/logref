---
message: "no data returned for index-only scan"
slug: no-data-returned-for-index-only-scan
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeIndexonlyscan.c:216"
  - "postgres/src/backend/utils/adt/selfuncs.c:7352"
reproduced: false
---

# `no data returned for index-only scan`

## What it means

Internal error. An index-only scan expected the index to supply a tuple's column values but received none. It is a consistency guard between the executor and the access method during index-only scans.

## When it happens

It fires when an index-only scan's `amgettuple` reports it can return the tuple from the index but then yields no data. Ordinary index-only scans do not surface it; it points to an internal bug or a damaged index.

## How to fix

This is a can't-happen guard. Try `REINDEX` on the index involved in case it is damaged. As a workaround, disabling index-only scans (`SET enable_indexonlyscan = off`) forces a heap fetch. Capture the query and report a reproducible case.

## Example

*Illustrative* — an index-only scan returning no tuple data.

```text
ERROR:  no data returned for index-only scan
```

## Related

- [no live root page found in index](./no-live-root-page-found-in-index.md)
- [index is not a btree](./index-is-not-a-btree.md)
