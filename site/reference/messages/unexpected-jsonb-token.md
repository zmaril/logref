---
message: "unexpected jsonb token: %d"
slug: unexpected-jsonb-token
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/jsonb_plperl/jsonb_plperl.c:86"
  - "postgres/contrib/jsonb_plperl/jsonb_plperl.c:129"
  - "postgres/contrib/jsonb_plpython/jsonb_plpython.c:163"
  - "postgres/contrib/jsonb_plpython/jsonb_plpython.c:224"
  - "postgres/contrib/jsonb_plpython/jsonb_plpython.c:258"
reproduced: false
---

# `unexpected jsonb token: %d`

## What it means

Internal error. Code converting between `jsonb` and another representation (here the `jsonb_plperl` transform) read a token from the `jsonb` iterator that it did not expect in that position. It is a consistency check on the `jsonb` token stream during conversion.

## When it happens

It should not occur for valid `jsonb` values. Reaching it suggests a bug in the transform/conversion code or corrupted `jsonb` input, not ordinary usage.

## How to fix

Treat it as an internal bug in the conversion path. If it involves a transform extension (`jsonb_plperl`, `jsonb_plpython`), suspect that. Capture the `jsonb` value and the function call and report it.

## Example

*Illustrative* — emitted internally during jsonb conversion.

```text
ERROR:  unexpected jsonb token: 7
```

## Related

- [invalid jsonb scalar type](./invalid-jsonb-scalar-type.md)
- [cannot call on a scalar](./cannot-call-on-a-scalar.md)
