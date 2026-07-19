---
message: "constraint must be PRIMARY, UNIQUE or EXCLUDE"
slug: constraint-must-be-primary-unique-or-exclude
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/index.c:1107"
reproduced: false
---

# `constraint must be PRIMARY, UNIQUE or EXCLUDE`

## What it means

Internal index/constraint code required a constraint that backs an index — a primary key, unique, or exclusion constraint — but was given another kind. This is a consistency check tying constraints to indexes.

## When it happens

It fires from index-creation internals when building the index that supports a constraint and the constraint type is not one of the index-backed kinds.

## How to fix

This is an internal error rather than a user setting. It can indicate an inconsistent catalog state. Capture the DDL that triggered it and inspect the constraint and its index; report it if it recurs on a healthy catalog.

## Example

*Illustrative* — a non-index constraint reaching index creation.

```text
ERROR:  constraint must be PRIMARY, UNIQUE or EXCLUDE
```

## Related

- [constraint in ON CONFLICT clause has no associated index](./constraint-in-on-conflict-clause-has-no-associated-index.md)
- [constraints cannot have index expressions](./constraints-cannot-have-index-expressions.md)
