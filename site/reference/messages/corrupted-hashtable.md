---
message: "corrupted hashtable"
slug: corrupted-hashtable
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/relfilenumbermap.c:245"
reproduced: false
---

# `corrupted hashtable`

## What it means

An internal hash table (here, the relfilenumber-to-relation map cache) was found in an inconsistent state. This is a consistency check on an in-memory structure; it indicates memory corruption or a serious bug rather than user data.

## When it happens

It fires when the relfilenumber map cache detects a broken entry while looking up a relation by its file number.

## How to fix

This is an internal error, not a user mistake. It can stem from memory corruption or a bug. Note what the server was doing, check system memory health, and report it; restarting the affected backend clears the in-memory cache.

## Example

*Illustrative* — a corrupted in-memory hash table.

```text
ERROR:  corrupted hashtable
```

## Related

- [corrupt MVNDistinct entry](./corrupt-mvndistinct-entry.md)
- [corrupted line pointer](./corrupted-line-pointer.md)
