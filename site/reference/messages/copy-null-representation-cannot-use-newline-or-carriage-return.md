---
message: "COPY null representation cannot use newline or carriage return"
slug: copy-null-representation-cannot-use-newline-or-carriage-return
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:847"
reproduced: false
---

# `COPY null representation cannot use newline or carriage return`

## What it means

A `COPY ... WITH (NULL '...')` option used a newline or carriage return in the null marker string. Those characters delimit rows, so they cannot appear in the null representation.

## When it happens

It happens on `COPY ... (NULL E'\n')` or similar when the null string contains a newline or carriage return.

## How to fix

Choose a `NULL` marker without newline or carriage-return characters, such as an empty string (the default for CSV) or `\N` (the default for text format).

## Example

*Illustrative* — a newline in the NULL marker.

```text
ERROR:  COPY null representation cannot use newline or carriage return
```

## Related

- [COPY default representation cannot use newline or carriage return](./copy-default-representation-cannot-use-newline-or-carriage-return.md)
- [COPY delimiter cannot be newline or carriage return](./copy-delimiter-cannot-be-newline-or-carriage-return.md)
