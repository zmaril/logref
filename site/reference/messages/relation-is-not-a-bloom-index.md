---
message: "Relation is not a bloom index"
slug: relation-is-not-a-bloom-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/bloom/blutils.c:198"
  - "postgres/contrib/bloom/blutils.c:202"
reproduced: false
---

# `Relation is not a bloom index`

## What it means

A `bloom` extension function was applied to a relation that is not a bloom index. Bloom-specific inspection or operations only make sense on an index built with the `bloom` access method.

## When it happens

It arises when calling a bloom-specific routine (or a page-inspection helper expecting a bloom index) against an ordinary table or a non-bloom index.

## How to fix

Pass a relation that is actually a bloom index. Verify with `\d` (or `pg_index`/`pg_am`) that the index uses the `bloom` access method before running bloom-specific operations on it.

## Example

*Illustrative* — a bloom function called on a non-bloom relation.

```text
ERROR:  Relation is not a bloom index
```

## Related

- [out of overflow pages in hash index "%s"](./out-of-overflow-pages-in-hash-index.md)
- [relation "%s" is of wrong relation kind](./relation-is-of-wrong-relation-kind.md)
