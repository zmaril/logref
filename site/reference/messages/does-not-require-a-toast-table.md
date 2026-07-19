---
message: "\"%s\" does not require a toast table"
slug: does-not-require-a-toast-table
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/toasting.c:113"
reproduced: false
---

# `"%s" does not require a toast table`

## What it means

An internal guard in the TOAST-creation code. Something asked to build a TOAST table for a relation whose columns never need out-of-line storage. The placeholder is the relation name. This is a "can't happen" check.

## When it happens

It fires when internal code requests a TOAST table for a relation whose row layout cannot exceed the threshold that requires one, which points at an internal inconsistency rather than user action.

## How to fix

This is not a user-facing condition. TOAST tables are managed automatically. If it recurs, capture the relation definition and the log context and report it to the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  "t" does not require a toast table
```

## Related

- [deletion of owning object failed to delete](./deletion-of-owning-object-failed-to-delete.md)
- [domain constraint has NULL conbin](./domain-constraint-has-null-conbin.md)
