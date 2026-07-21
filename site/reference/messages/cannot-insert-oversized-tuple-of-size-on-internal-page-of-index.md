---
message: "cannot insert oversized tuple of size %zu on internal page of index \"%s\""
slug: cannot-insert-oversized-tuple-of-size-on-internal-page-of-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtutils.c:1144"
reproduced: false
---

# `cannot insert oversized tuple of size %zu on internal page of index "%s"`

## What it means

An internal guard in the b-tree access method fired: a tuple too large for an internal (non-leaf) index page was about to be inserted there. Internal pages hold downlink tuples that must stay small, and this one exceeded the limit. The placeholders are the tuple size and index name.

## When it happens

It is reached during b-tree page splits when a pivot tuple grows past the internal-page size limit. It reflects an internal invariant rather than a routine user action, though very wide index keys make it more likely.

## How to fix

There is no direct user fix at the moment it fires. If it recurs, reduce the size of the indexed key — index a shorter expression or a prefix — so pivot tuples stay small, and report the case with the index definition.

## Example

*Illustrative* — a pivot tuple too large for an internal page.

```text
ERROR:  cannot insert oversized tuple of size 3200 on internal page of index "wide_idx"
```

## Related

- [cannot initialize non-empty hash index](./cannot-initialize-non-empty-hash-index.md)
- [cannot extend relation beyond blocks](./cannot-extend-relation-beyond-blocks.md)
