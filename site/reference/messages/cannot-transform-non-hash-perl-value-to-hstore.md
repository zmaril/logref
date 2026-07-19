---
message: "cannot transform non-hash Perl value to hstore"
slug: cannot-transform-non-hash-perl-value-to-hstore
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/hstore_plperl/hstore_plperl.c:127"
reproduced: false
---

# `cannot transform non-hash Perl value to hstore`

## What it means

A PL/Perl function returned a value to `hstore` that was not a Perl hash reference. The `hstore` transform expects key-value pairs, so a scalar, array, or other Perl value cannot be converted.

## When it happens

It occurs when a PL/Perl function declared to return `hstore` (with the `hstore_plperl` transform loaded) returns something other than a hash reference.

## How to fix

Return a hash reference from the function, for example `return { key => 'value' }`. Restructure the Perl code so the value handed back is a hash, not a scalar or array reference.

## Example

*Illustrative* — returning a non-hash to hstore.

```text
ERROR:  cannot transform non-hash Perl value to hstore
```

## Related

- [cannot transform this Perl type to jsonb](./cannot-transform-this-perl-type-to-jsonb.md)
- [cannot use JSON format with non-string output types](./cannot-use-json-format-with-non-string-output-types.md)
