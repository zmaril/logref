---
message: "could not determine data type of concat() input"
slug: could-not-determine-data-type-of-concat-input
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/varlena.c:4547"
reproduced: false
---

# `could not determine data type of concat() input`

## What it means

An internal call to `concat()`/`concat_ws()` handling could not determine the type of one of its inputs. This is an internal guard; the type-resolution machinery should have settled the input type before this point.

## When it happens

It fires inside the variadic concatenation functions when an argument's type is not known at execution. It is not normally reachable through ordinary SQL.

## How to fix

This is an internal error. If it appears from a specific query, note the exact call and argument types and report a reproducible case. There is no user-facing setting to adjust.

## Example

*Illustrative* — an input whose type is unresolved inside concat().

```text
ERROR:  could not determine data type of concat() input
```

## Related

- [could not convert epoch to timestamp](./could-not-convert-epoch-to-timestamp.md)
- [could not determine polymorphic type because input has type](./could-not-determine-polymorphic-type-because-input-has-type-ede818.md)
