---
message: "COPY default representation cannot use newline or carriage return"
slug: copy-default-representation-cannot-use-newline-or-carriage-return
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:857"
reproduced: false
---

# `COPY default representation cannot use newline or carriage return`

## What it means

A `COPY ... WITH (DEFAULT '...')` option used a newline or carriage return in the default marker string. Those characters delimit rows, so they cannot appear in the default representation.

## When it happens

It happens on `COPY FROM ... (DEFAULT E'\n')` or similar when the default string contains a newline or carriage return.

## How to fix

Choose a `DEFAULT` marker without newline or carriage-return characters. Use a distinctive printable string that will not appear in ordinary data.

## Example

*Illustrative* — a newline in the DEFAULT marker.

```text
ERROR:  COPY default representation cannot use newline or carriage return
```

## Related

- [COPY null representation cannot use newline or carriage return](./copy-null-representation-cannot-use-newline-or-carriage-return.md)
- [COPY delimiter cannot be newline or carriage return](./copy-delimiter-cannot-be-newline-or-carriage-return.md)
