---
message: "tuple already updated by self"
slug: tuple-already-updated-by-self
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:3168"
  - "postgres/src/backend/access/heap/heapam.c:4466"
  - "postgres/src/backend/access/table/tableam.c:331"
  - "postgres/src/backend/access/table/tableam.c:380"
reproduced: false
---

# `tuple already updated by self`

## What it means

Internal error. Heap code attempting to update a tuple found it had already been updated earlier in the same command by the same transaction, in a path that does not expect that. It is a consistency check within the update machinery, distinct from the user-facing `command cannot affect row a second time` error.

## When it happens

It does not arise from ordinary DML, which reports the cardinality-violation error instead when a row would be touched twice. Reaching this internal form points to a bug in an update path, a trigger, or an extension manipulating tuples directly.

## How to fix

Treat it as an internal bug. If it correlates with a specific trigger, rule, or extension, suspect that. Capture the statement and report it with a reproducer.

## Example

*Illustrative* — emitted internally during an update.

```text
ERROR:  tuple already updated by self
```

## Related

- [command cannot affect row a second time](./command-cannot-affect-row-a-second-time.md)
- [tuple concurrently updated](./tuple-concurrently-updated.md)
