---
message: "cannot modify reindex state during a parallel operation"
slug: cannot-modify-reindex-state-during-a-parallel-operation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/index.c:4211"
  - "postgres/src/backend/catalog/index.c:4224"
reproduced: false
---

# `cannot modify reindex state during a parallel operation`

## What it means

Internal error. Code tried to change the backend's reindexing-in-progress state while a parallel operation is active. The reindex state is shared with parallel workers and must not be mutated mid-flight. It is a consistency guard.

## When it happens

It should not occur through ordinary SQL. Reaching it points to an internal inconsistency between reindex bookkeeping and parallel execution, not to anything in your command.

## How to fix

Treat it as an internal bug. Capture the command — often a `REINDEX` interacting with parallel workers — and report it. Disabling parallelism for the operation is a temporary workaround if it recurs.

## Example

*Illustrative* — emitted internally during a parallel reindex.

```text
ERROR:  cannot modify reindex state during a parallel operation
```

## Related

- [cannot reindex while reindexing](./cannot-reindex-while-reindexing.md)
- [cannot update tuples during a parallel operation](./cannot-update-tuples-during-a-parallel-operation.md)
