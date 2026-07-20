---
message: "corrupted item lengths: total %zu, available space %u"
slug: corrupted-item-lengths-total-available-space
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/storage/page/bufpage.c:796"
  - "postgres/src/backend/storage/page/bufpage.c:1273"
reproduced: false
---

# `corrupted item lengths: total %zu, available space %u`

## What it means

While examining a heap or index page, Postgres found the item-pointer lengths sum to more space than the page actually has free. The placeholders are the computed total and the available space. The page's internal accounting is inconsistent, indicating corruption.

## When it happens

Reading a page whose line-pointer array or item lengths have been damaged — from a storage fault, bad hardware, or a bug — so the page fails its internal sanity check.

## How to fix

Treat it as page corruption. Identify the affected relation and page from the surrounding context, restore from a backup or a healthy replica where possible, and investigate the storage and memory subsystems. Run integrity checks (for example `amcheck` for indexes) to gauge the extent of the damage.

## Example

*Illustrative* — a page failing its space check.

```text
ERROR:  corrupted item lengths: total 9000, available space 8000
```

## Related

- [compressed pglz data is corrupt](./compressed-pglz-data-is-corrupt.md)
- [circular link chain found in block of index](./circular-link-chain-found-in-block-of-index.md)
