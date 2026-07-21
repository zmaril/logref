---
message: "tuple offset out of range: %u"
slug: tuple-offset-out-of-range
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/common/tidstore.c:375"
  - "postgres/src/backend/access/common/tidstore.c:396"
  - "postgres/src/backend/nodes/tidbitmap.c:383"
reproduced: false
---

# `tuple offset out of range: %u`

## What it means

Internal error. Code that stores or retrieves a tuple identifier found an item-offset component outside the valid range for a page. Tuple identifiers combine a block number and an item offset, and this offset was invalid.

## When it happens

It should not occur in normal operation. Reaching it points to a corrupt tuple identifier or an internal inconsistency, rather than to anything in your query.

## How to fix

Treat it as a corruption or internal-bug signal. Identify the table or index involved from surrounding context, check storage health, and reindex or restore affected data if corruption is confirmed. Capture the details and report it if the data appears sound.

## Example

*Illustrative* — an out-of-range tuple offset.

```text
ERROR:  tuple offset out of range: 40000
```

## Related

- [invalid index offnum](./invalid-index-offnum.md)
- [attempted to update or delete invisible tuple](./attempted-to-update-or-delete-invisible-tuple.md)
