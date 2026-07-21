---
message: "COPY delimiter cannot be newline or carriage return"
slug: copy-delimiter-cannot-be-newline-or-carriage-return
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:841"
reproduced: false
---

# `COPY delimiter cannot be newline or carriage return`

## What it means

A `COPY` delimiter was set to a newline or carriage return. Those characters end rows, so they cannot also serve as the field delimiter.

## When it happens

It happens on `COPY ... WITH (DELIMITER E'\n')` or similar.

## How to fix

Use a non-newline delimiter such as a comma or tab. Newline and carriage return are always row terminators in `COPY`.

## Example

*Illustrative* — a newline delimiter.

```text
ERROR:  COPY delimiter cannot be newline or carriage return
```

## Related

- [COPY delimiter cannot be](./copy-delimiter-cannot-be.md)
- [COPY null representation cannot use newline or carriage return](./copy-null-representation-cannot-use-newline-or-carriage-return.md)
