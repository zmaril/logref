---
message: "cannot add an object of this type to an extension"
slug: cannot-add-an-object-of-this-type-to-an-extension
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/extension.c:3795"
reproduced: false
---

# `cannot add an object of this type to an extension`

## What it means

An `ALTER EXTENSION ... ADD` command named an object of a kind that cannot be a member of an extension. Only certain object types can be tracked as extension members.

## When it happens

It occurs when running `ALTER EXTENSION name ADD <object>` for an object type that extension membership does not support.

## How to fix

Add only object types that extensions can own, such as tables, functions, types, and operators. For unsupported kinds, manage them outside the extension, or wrap the supporting object in one that can be a member.

## Example

*Illustrative* — adding an unsupported object type.

```sql
ALTER EXTENSION myext ADD ...;  -- object type not supported
```

## Related

- [cannot add schema to extension because the schema contains the extension](./cannot-add-schema-to-extension-because-the-schema-contains-the-extension.md)
- [can only be called from an sql script executed by create extension](./can-only-be-called-from-an-sql-script-executed-by-create-extension.md)
