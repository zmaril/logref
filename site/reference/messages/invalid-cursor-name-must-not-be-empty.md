---
message: "invalid cursor name: must not be empty"
slug: invalid-cursor-name-must-not-be-empty
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_CURSOR_NAME
    code: "34000"
call_sites:
  - "postgres/src/backend/commands/portalcmds.c:61"
  - "postgres/src/backend/commands/portalcmds.c:190"
  - "postgres/src/backend/commands/portalcmds.c:241"
reproduced: false
---

# `invalid cursor name: must not be empty`

## What it means

A cursor operation was given an empty string as the cursor name. Every cursor is identified by a non-empty name, so an empty name cannot refer to any cursor and cannot be used to declare one.

## When it happens

Issuing `DECLARE`, `FETCH`, `MOVE`, or `CLOSE` with an empty string for the cursor name — usually because the name came from a variable or client parameter that was blank.

## How to fix

Supply a non-empty cursor name. If the name is built from application input, validate it before use so a blank value is caught before it reaches the database.

## Example

*Illustrative* — an empty cursor name.

```sql
CLOSE "";  -- cursor name must not be empty
```

## Related

- [cursor does not exist](./cursor-does-not-exist.md)
- [invalid value for option](./invalid-value-for-option.md)
