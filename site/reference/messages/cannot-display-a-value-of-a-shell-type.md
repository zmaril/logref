---
message: "cannot display a value of a shell type"
slug: cannot-display-a-value-of-a-shell-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/pseudotypes.c:315"
reproduced: false
---

# `cannot display a value of a shell type`

## What it means

An attempt was made to output a value whose type is a shell type — a placeholder created by `CREATE TYPE name` before the type's full definition exists. A shell type has no output function, so its values cannot be displayed.

## When it happens

It occurs when a query produces a value of a not-yet-completed shell type, typically during a partial or interrupted type-definition sequence.

## How to fix

Complete the type definition so it has input and output functions before using its values, or avoid selecting values of an unfinished shell type. Finish the `CREATE TYPE` before relying on the type.

## Example

*Illustrative* — displaying a shell-type value.

```text
ERROR:  cannot display a value of a shell type
```

## Related

- [cannot assign new oid to existing shell type](./cannot-assign-new-oid-to-existing-shell-type.md)
- [cannot change type's storage to plain](./cannot-change-type-s-storage-to-plain.md)
