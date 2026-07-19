---
message: "type %u does not match constructor type"
slug: type-does-not-match-constructor-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/multirangetypes.c:991"
  - "postgres/src/backend/utils/adt/multirangetypes.c:1054"
reproduced: false
---

# `type %u does not match constructor type`

## What it means

Internal error. A value's type did not match the composite/constructor type it was being placed into. The placeholder is the type OID. It is a type-consistency check during row or value construction.

## When it happens

It fires from expression-evaluation code building a composite or typed value when an element's type disagrees with the target constructor's expected type. Ordinary queries with type mismatches produce specific cast/type errors instead.

## How to fix

This is an internal consistency guard. If a real query triggers it, capture the statement and any custom types/functions involved and report it as a reproducible bug.

## Example

*Illustrative* — a value not matching its constructor type.

```text
ERROR:  type 16385 does not match constructor type
```

## Related

- [record type has not been registered](./record-type-has-not-been-registered.md)
- [type mismatch in hypothetical-set function](./type-mismatch-in-hypothetical-set-function.md)
