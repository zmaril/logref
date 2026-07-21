---
message: "cannot change type's storage to PLAIN"
slug: cannot-change-type-s-storage-to-plain
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:4420"
reproduced: false
---

# `cannot change type's storage to PLAIN`

## What it means

An `ALTER TYPE ... SET (STORAGE = PLAIN)` tried to give a type `PLAIN` storage that requires an extended storage strategy. A variable-length type must allow out-of-line or compressed storage, so it cannot be forced to `PLAIN`.

## When it happens

It occurs when setting a variable-length base type's storage to `PLAIN` through `ALTER TYPE`.

## How to fix

Choose an extended storage strategy such as `EXTENDED`, `EXTERNAL`, or `MAIN` for variable-length types. Only fixed-length types use `PLAIN` storage.

## Example

*Illustrative* — forcing PLAIN storage.

```text
ERROR:  cannot change type's storage to PLAIN
```

## Related

- [cannot change return type of existing function](./cannot-change-return-type-of-existing-function.md)
- [cannot change schema of composite type](./cannot-change-schema-of-composite-type.md)
