---
message: "COPY %s requires %s to be set to %s"
slug: copy-requires-to-be-set-to
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:1045"
reproduced: false
---

# `COPY %s requires %s to be set to %s`

## What it means

A `COPY` option was used that requires another option to hold a specific value, and that prerequisite was not met. The message names the option, the dependency, and the required value.

## When it happens

It happens on `COPY ... WITH (...)` when an option is only valid alongside a particular setting of another option (for example a CSV-only option without `FORMAT csv`).

## How to fix

Set the prerequisite option to the required value shown in the message, or remove the dependent option. Align the `COPY` options so the dependency is satisfied.

## Example

*Illustrative* — an option missing its prerequisite.

```text
ERROR:  COPY HEADER requires FORMAT to be set to csv or text
```

## Related

- [COPY can only be used with JSON mode](./copy-can-only-be-used-with-json-mode.md)
- [COPY format not recognized](./copy-format-not-recognized.md)
