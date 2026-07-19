---
message: "domain data types must not be marked binary-compatible"
slug: domain-data-types-must-not-be-marked-binary-compatible
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1765"
reproduced: false
---

# `domain data types must not be marked binary-compatible`

## What it means

`CREATE CAST ... WITHOUT FUNCTION` (a binary-compatible cast) named a domain as one of its types. Binary-coercible casts are defined between base types, not domains, so a domain may not participate.

## When it happens

It fires from `CREATE CAST` when the source or target type is a domain and the cast is declared `WITHOUT FUNCTION`.

## How to fix

Define the binary-compatible cast between the underlying base types, not the domain. A domain already inherits its base type's casts, so a separate binary cast for the domain is neither needed nor allowed.

## Example

*Illustrative* — a binary cast involving a domain.

```sql
CREATE CAST (mydomain AS text) WITHOUT FUNCTION;
-- domain data types must not be marked binary-compatible
```

## Related

- [enum data types are not binary-compatible](./enum-data-types-are-not-binary-compatible.md)
- [element type cannot be specified without a subscripting function](./element-type-cannot-be-specified-without-a-subscripting-function.md)
