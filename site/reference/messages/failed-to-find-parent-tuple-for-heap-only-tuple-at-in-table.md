---
message: "failed to find parent tuple for heap-only tuple at (%u,%u) in table \"%s\""
slug: failed-to-find-parent-tuple-for-heap-only-tuple-at-in-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/access/heap/heapam_handler.c:1653"
  - "postgres/src/backend/access/heap/heapam_handler.c:1830"
reproduced: false
---

# `failed to find parent tuple for heap-only tuple at (%u,%u) in table "%s"`

## What it means

Data corruption was detected. A heap-only tuple (HOT) had no parent tuple in its update chain. The `(%u,%u)` is the item pointer and the `%s` is the table. A broken HOT chain indicates heap corruption.

## When it happens

It fires during scans, VACUUM, or maintenance that walk HOT chains, when the chain's root could not be found — a sign of on-disk heap damage.

## How to fix

Treat this as heap corruption. Check storage health, and consider `VACUUM` and integrity tools to assess the damage. Restore the affected table from a known-good backup if the heap is damaged, and investigate the underlying cause.

## Example

*Illustrative* — a HOT chain with no parent tuple.

```text
ERROR:  failed to find parent tuple for heap-only tuple at (5,3) in table "orders"
```

## Related

- [could not read blocks in file: read only of bytes](./could-not-read-blocks-in-file-read-only-of-bytes.md)
- [failed to fetch the target tuple](./failed-to-fetch-the-target-tuple.md)
