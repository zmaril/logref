---
message: "\"%s\" (%d) should be less than or equal to \"%s\" (%d)"
slug: should-be-less-than-or-equal-to
passthrough: false
api: [ereport]
level: [WARNING]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/postmaster/autovacuum.c:3634"
  - "postgres/src/backend/storage/aio/method_worker.c:677"
reproduced: false
---

# `"%s" (%d) should be less than or equal to "%s" (%d)`

## What it means

Two related configuration values are inconsistent: one that must not exceed another was set higher, so the server is warning that the pair does not make sense together.

## When it happens

It is emitted at WARNING when settings with an ordering relationship are checked against each other — for example a minimum that exceeds a maximum, or a soft limit above a hard limit.

## Is this a problem?

Adjust the two parameters so the first is at most the second, then reload. The server usually clamps or continues with a fallback, but you should fix the configuration so behavior is what you intend.

## Example

*Illustrative* — a lower bound set above its upper bound.

```text
WARNING:  "min_val" (100) should be less than or equal to "max_val" (50)
```

## Related

- [a negative integer value cannot be specified for](./a-negative-integer-value-cannot-be-specified-for.md)
- [unrecognized configuration parameter](./unrecognized-configuration-parameter.md)
