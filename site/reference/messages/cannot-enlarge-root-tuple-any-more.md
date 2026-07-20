---
message: "cannot enlarge root tuple any more"
slug: cannot-enlarge-root-tuple-any-more
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/spgist/spgdoinsert.c:1584"
reproduced: false
---

# `cannot enlarge root tuple any more`

## What it means

An internal guard in SP-GiST index building: the code could not make the root tuple larger to hold more entries. The root tuple has reached a size limit imposed by the page layout, so it cannot grow further.

## When it happens

It is a can't-happen guard reached during SP-GiST index construction with an unusual key distribution. It reflects an internal limit rather than a routine user error.

## How to fix

There is no direct user-level fix. If it appears, capture the index definition, the operator class, and a sample of the data and report it, since normal builds do not exhaust the root tuple this way.

## Example

*Illustrative* — the root-tuple size guard.

```text
ERROR:  cannot enlarge root tuple any more
```

## Related

- [cannot create new tapes in leader process](./cannot-create-new-tapes-in-leader-process.md)
- [cannot compare rows of zero length](./cannot-compare-rows-of-zero-length.md)
