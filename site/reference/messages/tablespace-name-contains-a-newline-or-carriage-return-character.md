---
message: "tablespace name \"%s\" contains a newline or carriage return character"
slug: tablespace-name-contains-a-newline-or-carriage-return-character
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/tablespace.c:248"
  - "postgres/src/backend/commands/tablespace.c:983"
reproduced: false
---

# `tablespace name "%s" contains a newline or carriage return character`

## What it means

A tablespace name contained a newline or carriage-return character. The placeholder is the offending name. Control characters are disallowed because a tablespace name flows into paths and configuration where they would be dangerous.

## When it happens

It arises from `CREATE`/`ALTER TABLESPACE` when the name (often from untrusted input) has an embedded `\n` or `\r`.

## How to fix

Remove control characters from the tablespace name. Validate names against an allowed character set and never construct them from unsanitized external input.

## Example

*Illustrative* — a tablespace name with an embedded newline.

```text
ERROR:  tablespace name "bad\nname" contains a newline or carriage return character
```

## Related

- [role name "%s" contains a newline or carriage return character](./role-name-contains-a-newline-or-carriage-return-character.md)
- [unacceptable tablespace name "%s"](./unacceptable-tablespace-name.md)
