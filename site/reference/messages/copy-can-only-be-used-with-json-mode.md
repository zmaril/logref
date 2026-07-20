---
message: "COPY %s can only be used with JSON mode"
slug: copy-can-only-be-used-with-json-mode
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:999"
reproduced: false
---

# `COPY %s can only be used with JSON mode`

## What it means

A `COPY` option that is only meaningful in JSON format was used with a non-JSON format. That option requires `FORMAT json`, so it is rejected otherwise.

## When it happens

It happens on `COPY ... WITH (...)` when a JSON-only option (such as one controlling JSON output shape) is combined with `text` or `csv` format.

## How to fix

Use `FORMAT json` if you need the JSON-specific option, or remove that option when copying in text or CSV format.

## Example

*Illustrative* — a JSON-only option in text mode.

```text
ERROR:  COPY FORCE_NULL can only be used with JSON mode
```

## Related

- [COPY format not recognized](./copy-format-not-recognized.md)
- [COPY requires to be set to](./copy-requires-to-be-set-to.md)
