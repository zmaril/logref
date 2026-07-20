---
message: "cache entry already complete"
slug: cache-entry-already-complete
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeMemoize.c:894"
reproduced: false
---

# `cache entry already complete`

## What it means

Internal code tried to finish building a cache entry that was already marked complete. Completing an entry twice violates the cache's construction protocol. It is an internal consistency check.

## When it happens

It is a can't-happen guard in cache construction and does not arise from ordinary SQL.

## How to fix

There is no user action. If it appears, capture the surrounding operation and any extensions that manipulate caches, and report it as a possible bug with the server version.

## Example

*Illustrative* — the double-completion guard.

```text
ERROR:  cache entry already complete
```

## Related

- [cache lookup failed for oid](./cache-lookup-failed-for-oid.md)
- [callback is out of range](./callback-is-out-of-range.md)
