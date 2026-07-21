---
message: "cannot alter array type %s"
slug: cannot-alter-array-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:3832"
  - "postgres/src/backend/commands/typecmds.c:3917"
  - "postgres/src/backend/commands/typecmds.c:4159"
reproduced: false
---

# `cannot alter array type %s`

## What it means

An `ALTER TYPE` targeted an automatically-generated array type (the `_typename` companion Postgres creates for every base/composite type). The placeholder names the array type. These array types are managed by the system as an adjunct to their element type and cannot be altered directly.

## When it happens

Running `ALTER TYPE` on the implicit array type of some other type — often by mistakenly naming the `_name`/`name[]` form instead of the element type.

## How to fix

Alter the element type instead; its array type follows automatically. If you meant to change the base or composite type, name that type in the `ALTER TYPE`. There is no supported way to alter the generated array type on its own.

## Example

*Illustrative* — altering an implicit array type.

```sql
ALTER TYPE _myenum ADD VALUE 'x';  -- cannot alter array type _myenum
```

## Related

- [operator attribute cannot be changed if it has already been set](./operator-attribute-cannot-be-changed-if-it-has-already-been-set.md)
- [cannot subscript type because it does not support subscripting](./cannot-subscript-type-because-it-does-not-support-subscripting.md)
