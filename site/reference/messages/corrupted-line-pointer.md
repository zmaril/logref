---
message: "corrupted line pointer: %u"
slug: corrupted-line-pointer
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/storage/page/bufpage.c:766"
reproduced: false
---

# `corrupted line pointer: %u`

## What it means

A heap or index page held a line pointer whose value is invalid. Line pointers index the tuples on a page, so a bad one means the page is corrupted and cannot be read safely.

## When it happens

It happens when reading a page (during a scan, vacuum, or update) whose line-pointer array is damaged, typically from storage corruption.

## How to fix

Treat this as data corruption. Identify the affected relation and page, restore the table from a known-good backup, and run hardware/storage diagnostics. Tools like `pg_amcheck` help locate damage; do not ignore it, as more of the table may be affected.

## Example

*Illustrative* — a corrupted line pointer on a page.

```text
ERROR:  corrupted line pointer: 12
```

## Related

- [corrupted line pointer offset size](./corrupted-line-pointer-offset-size-3ff348.md)
- [corrupted hashtable](./corrupted-hashtable.md)
