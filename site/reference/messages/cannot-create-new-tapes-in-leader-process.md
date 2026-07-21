---
message: "cannot create new tapes in leader process"
slug: cannot-create-new-tapes-in-leader-process
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/sort/logtape.c:690"
reproduced: false
---

# `cannot create new tapes in leader process`

## What it means

An internal guard in parallel sort or hash: the leader process was asked to create new logical tapes, which only worker processes may do in this phase. The leader consumes tapes that workers produced, so creating them there is a consistency error.

## When it happens

It is a can't-happen check in the tape-based sort/spill machinery reached during parallel operations. It would only surface from a bug in that code.

## How to fix

There is no user-level fix. If it appears, capture the query, the parallel settings, and any extension involved and report it, since normal parallel sorts do not reach this guard.

## Example

*Illustrative* — the leader-tape guard.

```text
ERROR:  cannot create new tapes in leader process
```

## Related

- [cannot create temporary tables during a parallel operation](./cannot-create-temporary-tables-during-a-parallel-operation.md)
- [cannot enlarge root tuple any more](./cannot-enlarge-root-tuple-any-more.md)
