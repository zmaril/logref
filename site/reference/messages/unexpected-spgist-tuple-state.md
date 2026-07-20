---
message: "unexpected SPGiST tuple state: %d"
slug: unexpected-spgist-tuple-state
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/spgist/spgdoinsert.c:286"
  - "postgres/src/backend/access/spgist/spgdoinsert.c:368"
  - "postgres/src/backend/access/spgist/spgdoinsert.c:445"
  - "postgres/src/backend/access/spgist/spgdoinsert.c:763"
  - "postgres/src/backend/access/spgist/spgdoinsert.c:799"
  - "postgres/src/backend/access/spgist/spgscan.c:793"
  - "postgres/src/backend/access/spgist/spgscan.c:905"
  - "postgres/src/backend/access/spgist/spgvacuum.c:265"
  - "postgres/src/backend/access/spgist/spgvacuum.c:444"
  - "postgres/src/backend/access/spgist/spgvacuum.c:782"
reproduced: false
---

# `unexpected SPGiST tuple state: %d`

## What it means

Internal error. Code walking an SP-GiST index found a tuple whose state flag is not one it expects. The placeholder is the numeric state. SP-GiST tuples carry a state (live, redirect, dead, placeholder); an unexpected value indicates an index inconsistency or a bug.

## When it happens

SP-GiST index corruption, a bug in a custom SP-GiST operator class, or an interrupted index operation leaving inconsistent state. Ordinary queries do not produce it unless the index is damaged.

## How to fix

Suspect index corruption first: `REINDEX` the affected SP-GiST index, which rebuilds it from the table. If a custom opclass is involved, suspect its code. If reindex does not clear it or it recurs, verify hardware/memory and report a reproducible case. Check `amcheck` where applicable.

## Example

*Illustrative* — a damaged SP-GiST index scanned.

```text
ERROR:  unexpected SPGiST tuple state: 3
```

## Related

- [failed to add item of size %u to SPGiST index page](./failed-to-add-item-of-size-to-spgist-index-page-63086a.md)
- [index contains corrupted page at block](./index-contains-corrupted-page-at-block.md)
