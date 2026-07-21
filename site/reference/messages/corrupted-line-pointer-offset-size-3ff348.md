---
message: "corrupted line pointer: offset = %u, size = %d"
slug: corrupted-line-pointer-offset-size-3ff348
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/storage/page/bufpage.c:1449"
reproduced: false
---

# `corrupted line pointer: offset = %u, size = %d`

## What it means

A page's line pointer described a tuple location (offset and size) that is inconsistent with the page layout. The pointer points outside the valid region, so the page is corrupted.

## When it happens

It happens when reading a page whose line-pointer offset/size values are invalid, generally due to storage-level corruption.

## How to fix

Treat this as data corruption. Locate the affected relation and page, restore from a good backup, and check storage hardware. Use `pg_amcheck` to assess the extent of the damage; a page with invalid line pointers cannot be trusted.

## Example

*Illustrative* — an invalid line-pointer offset/size.

```text
ERROR:  corrupted line pointer: offset = 8200, size = 40
```

## Related

- [corrupted line pointer](./corrupted-line-pointer.md)
- [corrupted hashtable](./corrupted-hashtable.md)
