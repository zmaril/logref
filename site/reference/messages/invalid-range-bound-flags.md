---
message: "invalid range bound flags"
slug: invalid-range-bound-flags
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/utils/adt/rangetypes.c:2488"
  - "postgres/src/backend/utils/adt/rangetypes.c:2501"
  - "postgres/src/backend/utils/adt/rangetypes.c:2515"
reproduced: false
---

# `invalid range bound flags`

## What it means

Internal error. A range value was constructed with a combination of boundary flags that is not valid. The flags encode which bounds are inclusive, exclusive, infinite, or empty, and this combination is not one the range machinery produces.

## When it happens

It should not occur through normal SQL range construction. Reaching it points to a malformed binary range value or an internal inconsistency, rather than to a range literal you wrote.

## How to fix

Treat it as an internal or input-integrity problem. If the value arrives over the binary protocol from a client, check the driver's range encoder. Otherwise capture the operation and report it, since range constructors built through SQL should not produce invalid flag combinations.

## Example

*Illustrative* — a malformed set of range bound flags.

```text
ERROR:  invalid range bound flags
```

## Related

- [upper bound cannot be less than lower bound](./upper-bound-cannot-be-less-than-lower-bound.md)
- [invalid strategy in partition bound spec](./invalid-strategy-in-partition-bound-spec.md)
