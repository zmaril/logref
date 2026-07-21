---
message: "cannot transform this Perl type to jsonb"
slug: cannot-transform-this-perl-type-to-jsonb
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/jsonb_plperl/jsonb_plperl.c:276"
reproduced: false
---

# `cannot transform this Perl type to jsonb`

## What it means

A PL/Perl value could not be mapped to `jsonb`. The `jsonb` transform handles scalars, array references, hash references, and the JSON boolean and null helpers, but the value it received was some other Perl type such as a code or glob reference.

## When it happens

It occurs when a PL/Perl function returning `jsonb` (with the `jsonb_plperl` transform loaded) produces a Perl value that has no JSON equivalent.

## How to fix

Return only JSON-representable values: numbers, strings, array references, hash references, and the transform's boolean/null helpers. Convert other Perl structures to one of these before returning.

## Example

*Illustrative* — an unsupported Perl type to jsonb.

```text
ERROR:  cannot transform this Perl type to jsonb
```

## Related

- [cannot transform non-hash Perl value to hstore](./cannot-transform-non-hash-perl-value-to-hstore.md)
- [cannot use JSON format with non-string output types](./cannot-use-json-format-with-non-string-output-types.md)
