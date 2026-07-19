---
message: "%s is not an enum"
slug: is-not-an-enum
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:1361"
  - "postgres/src/backend/utils/cache/typcache.c:2782"
reproduced: false
---

# `%s is not an enum`

## What it means

An operation that requires an enum type was given a type that is not an enum. The placeholder names the type. Enum-specific commands only apply to enum types.

## When it happens

It arises from `ALTER TYPE ... ADD VALUE`/`RENAME VALUE` or enum functions like `enum_range`/`enum_first` when the named type is a base, composite, or other non-enum type.

## How to fix

Name an enum type for enum operations. Check a type's category with `\dT name` or `pg_type.typtype = 'e'`. If you need to add a member to a non-enum type, that operation does not apply; use the command suited to the type.

## Example

*Illustrative* — an enum operation on a non-enum type.

```sql
ALTER TYPE integer ADD VALUE 'x';  -- integer is not an enum
```

## Related

- [is not an existing enum label](./is-not-an-existing-enum-label.md)
- [invalid input value for enum](./invalid-input-value-for-enum.md)
