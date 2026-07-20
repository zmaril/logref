---
message: "could not validate \"%s\" object: invalid attribute number %d found"
slug: could-not-validate-object-invalid-attribute-number-found
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_INVALID_TEXT_REPRESENTATION
    code: "22P02"
call_sites:
  - "postgres/src/backend/statistics/dependencies.c:646"
  - "postgres/src/backend/statistics/mvdistinct.c:392"
reproduced: false
---

# `could not validate "%s" object: invalid attribute number %d found`

## What it means

An object-validation step found an attribute (column) number that is out of range for the object it was checking, so the object failed validation.

## When it happens

It arises when validating an object whose stored attribute references do not line up with its current shape — for example during a check that catalog references are consistent.

## Is this a problem?

The referenced object's metadata appears inconsistent. Capture the object and the surrounding context; if it involves a stored definition, re-creating that object can restore valid references. Report a reproducible case if it recurs.

## Example

*Illustrative* — an out-of-range attribute number.

```text
ERROR:  could not validate "mystats" object: invalid attribute number 5 found
```

## Related

- [could not find schema "%s"](./could-not-find-schema.md)
- [invalid configuration parameter name "%s"](./invalid-configuration-parameter-name.md)
