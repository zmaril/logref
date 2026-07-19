---
message: "COPY delimiter cannot be \"%s\""
slug: copy-delimiter-cannot-be
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:875"
reproduced: false
---

# `COPY delimiter cannot be "%s"`

## What it means

A `COPY` delimiter was set to a character that is not allowed as a delimiter (for example a character that conflicts with the format's structure). The chosen delimiter is rejected.

## When it happens

It happens on `COPY ... WITH (DELIMITER 'x')` when `x` is a reserved or unsafe delimiter such as a backslash in certain contexts.

## How to fix

Pick a different single-byte delimiter that does not conflict with the format, such as a comma, tab, or pipe. Avoid characters that carry special meaning in the copy format.

## Example

*Illustrative* — a disallowed delimiter.

```text
ERROR:  COPY delimiter cannot be "\\"
```

## Related

- [COPY delimiter must be a single one-byte character](./copy-delimiter-must-be-a-single-one-byte-character.md)
- [COPY delimiter cannot be newline or carriage return](./copy-delimiter-cannot-be-newline-or-carriage-return.md)
