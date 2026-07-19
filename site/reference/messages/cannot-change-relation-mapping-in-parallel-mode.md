---
message: "cannot change relation mapping in parallel mode"
slug: cannot-change-relation-mapping-in-parallel-mode
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/relmapper.c:352"
reproduced: false
---

# `cannot change relation mapping in parallel mode`

## What it means

An internal guard: code tried to update the relation map — the file that records physical locations of mapped catalogs — while a parallel operation was active. Relation-map changes must happen in the leader outside parallel mode, so this is refused.

## When it happens

It is a can't-happen check reached if a catalog rewrite that remaps a nailed relation runs inside a parallel context. It reflects a coding issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the operation and any extension involved and report it, since relation-map updates should never occur in parallel mode.

## Example

*Illustrative* — a relation-map change in parallel mode.

```text
ERROR:  cannot change relation mapping in parallel mode
```

## Related

- [cannot change relation mapping within subtransaction](./cannot-change-relation-mapping-within-subtransaction.md)
- [cannot assign transactionids during a parallel operation](./cannot-assign-transactionids-during-a-parallel-operation.md)
