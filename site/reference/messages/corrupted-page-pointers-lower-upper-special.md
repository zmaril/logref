---
message: "corrupted page pointers: lower = %u, upper = %u, special = %u"
slug: corrupted-page-pointers-lower-upper-special
passthrough: false
api: [ereport]
level: [ERROR, PANIC]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/storage/page/bufpage.c:224"
  - "postgres/src/backend/storage/page/bufpage.c:737"
  - "postgres/src/backend/storage/page/bufpage.c:1080"
  - "postgres/src/backend/storage/page/bufpage.c:1215"
  - "postgres/src/backend/storage/page/bufpage.c:1321"
  - "postgres/src/backend/storage/page/bufpage.c:1433"
reproduced: false
---

# `corrupted page pointers: lower = %u, upper = %u, special = %u`

## What it means

A page's internal pointers failed a sanity check. Every page header records `lower`, `upper`, and `special` offsets that partition the page; the check found values that are inconsistent (out of order or out of bounds). The placeholders are the three offsets. It is a corruption guard that can reach `PANIC` during recovery.

## When it happens

Page corruption from failing storage, a bug, or a damaged WAL record replayed against a page. The `DATA_CORRUPTED` SQLSTATE marks it as an integrity failure. Healthy pages always pass this check.

## How to fix

Treat it as corruption. Identify the affected relation and page, verify with `amcheck` (indexes) or heap inspection, and restore the damaged data from a known-good backup. Check storage health — a corrupt page header often accompanies hardware faults. A `PANIC` during recovery indicates a bad page or WAL record; investigate before forcing the server up. Report reproducible cases.

## Example

*Illustrative* — a page failing the pointer sanity check.

```text
ERROR:  corrupted page pointers: lower = 8200, upper = 40, special = 8192
```

## Related

- [invalid lp](./invalid-lp.md)
- [index "%s" contains corrupted page at block %u](./index-contains-corrupted-page-at-block.md)
