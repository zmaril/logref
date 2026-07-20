---
message: "EAN13 failed check"
slug: ean13-failed-check
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/isn/isn.c:910"
reproduced: false
---

# `EAN13 failed check`

## What it means

An internal guard in the `isn` extension. Converting a value to `EAN13` produced a result that failed the format's own check-digit validation, when the input was expected to be valid already. This is a "should not happen" check.

## When it happens

It fires inside the `isn` extension while building an `EAN13` value, when the internal check-digit computation does not agree, indicating an inconsistency in the conversion path.

## How to fix

This is not a routine user error. If it reproduces on a specific input, capture that input and the extension version and report it to the PostgreSQL developers. Validate ISBN/ISSN/EAN inputs before casting to catch ordinary bad data as a normal validation error instead.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  EAN13 failed check
```

## Related

- [encrypt error](./encrypt-error.md)
- [empty query](./empty-query.md)
