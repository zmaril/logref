---
message: "role name \"%s\" contains a newline or carriage return character"
slug: role-name-contains-a-newline-or-carriage-return-character
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/user.c:176"
  - "postgres/src/backend/commands/user.c:1359"
reproduced: false
---

# `role name "%s" contains a newline or carriage return character`

## What it means

A role name contained a newline or carriage-return character. The placeholder is the offending name. Such control characters are disallowed in role names because they could corrupt configuration files and log output.

## When it happens

It arises from `CREATE`/`ALTER ROLE` when the name (often built from untrusted input) contains an embedded `\n` or `\r`.

## How to fix

Strip control characters from the role name before using it. Validate names against an allowed character set, and never build role names from unsanitized external input.

## Example

*Illustrative* — a role name with an embedded newline.

```text
ERROR:  role name "bad\nname" contains a newline or carriage return character
```

## Related

- [tablespace name "%s" contains a newline or carriage return character](./tablespace-name-contains-a-newline-or-carriage-return-character.md)
- [role "%s" already exists](./role-already-exists.md)
