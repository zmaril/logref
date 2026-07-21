---
message: "%s is already a member of extension \"%s\""
slug: is-already-a-member-of-extension
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/catalog/pg_depend.c:234"
  - "postgres/src/backend/commands/extension.c:3881"
reproduced: false
---

# `%s is already a member of extension "%s"`

## What it means

An `ALTER EXTENSION ... ADD` tried to add an object to an extension, but the object already belongs to an extension. An object can be a member of at most one extension. The placeholders are the object and the extension.

## When it happens

It arises when running `ALTER EXTENSION ext ADD object` for an object that a `CREATE EXTENSION` (or an earlier `ADD`) already recorded as owned by that extension or another one.

## How to fix

If the object is already part of the intended extension, no action is needed. If it belongs to a different extension, remove it there first with `ALTER EXTENSION other DROP object`, then add it. Objects created by an extension's install script are members automatically.

## Example

*Illustrative* — adding an object that is already a member.

```sql
ALTER EXTENSION myext ADD FUNCTION f();  -- f() is already a member
```

## Related

- [invalid character in extension schema must not contain any of](./invalid-character-in-extension-schema-must-not-contain-any-of.md)
- [is not yet supported in unquoted SQL function body](./is-not-yet-supported-in-unquoted-sql-function-body.md)
