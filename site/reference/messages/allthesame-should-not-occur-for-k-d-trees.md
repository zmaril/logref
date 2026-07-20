---
message: "allTheSame should not occur for k-d trees"
slug: allthesame-should-not-occur-for-k-d-trees
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/spgist/spgkdtreeproc.c:64"
  - "postgres/src/backend/access/spgist/spgkdtreeproc.c:175"
reproduced: false
---

# `allTheSame should not occur for k-d trees`

## What it means

Internal error. SP-GiST code for k-d trees reached a state flagged for the quadtree variant that should never arise in a k-d tree. It is a consistency check inside the SP-GiST access method.

## When it happens

It should not occur in normal operation. Reaching it points to an internal inconsistency in the SP-GiST k-d tree implementation or a corrupt index, not to your query.

## How to fix

Treat it as an internal-bug or corruption signal. Identify the SP-GiST index involved, `REINDEX` it in case of corruption, and if it recurs on a rebuilt index, capture the details and report it.

## Example

*Illustrative* — an unexpected SP-GiST state.

```text
ERROR:  allTheSame should not occur for k-d trees
```

## Related

- [invalid index offnum](./invalid-index-offnum.md)
- [missing support function for attribute of index](./missing-support-function-for-attribute-of-index-26abc2.md)
