---
message: "invalid parameter list format: \"%s\""
slug: invalid-parameter-list-format
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/tsearchcmds.c:1705"
  - "postgres/src/backend/commands/tsearchcmds.c:1820"
reproduced: false
---

# `invalid parameter list format: "%s"`

## What it means

A packed parameter list string could not be parsed. The placeholder shows the text that failed. This format is used to serialize a set of key/value parameters into a single string.

## When it happens

It arises where the server stores or reads a parameter list as text — for example a background worker's parameters or certain internal option encodings — and the string is malformed.

## How to fix

If you are constructing the parameter string, follow the exact escaping the format requires (quoted values, doubled quotes inside values). Where the string comes from a tool or extension, that producer is emitting a malformed list; fix it there.

## Example

*Illustrative* — a malformed packed parameter list.

```text
ERROR:  invalid parameter list format: "a=
```

## Related

- [invalid connection string syntax](./invalid-connection-string-syntax.md)
- [invalid option name must not contain](./invalid-option-name-must-not-contain.md)
