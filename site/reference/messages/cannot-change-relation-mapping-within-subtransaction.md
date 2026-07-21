---
message: "cannot change relation mapping within subtransaction"
slug: cannot-change-relation-mapping-within-subtransaction
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/relmapper.c:349"
reproduced: false
---

# `cannot change relation mapping within subtransaction`

## What it means

An internal guard: code tried to update the relation map while inside a subtransaction. Relation-map changes are not subtransaction-aware, so they must occur at the top transaction level, and doing so within a savepoint is refused.

## When it happens

It is a can't-happen check reached if a catalog operation that remaps a nailed relation runs inside a savepoint or PL/pgSQL exception block. It reflects a coding issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the statement and context and report it, since relation-map updates should never happen inside a subtransaction.

## Example

*Illustrative* — a relation-map change in a subtransaction.

```text
ERROR:  cannot change relation mapping within subtransaction
```

## Related

- [cannot change relation mapping in parallel mode](./cannot-change-relation-mapping-in-parallel-mode.md)
- [cannot change access method of mapped relation](./cannot-change-access-method-of-mapped-relation.md)
