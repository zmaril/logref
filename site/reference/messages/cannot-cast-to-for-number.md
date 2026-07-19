---
message: "cannot cast %s to %s for number: \"%s\""
slug: cannot-cast-to-for-number
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TEXT_REPRESENTATION
    code: "22P02"
call_sites:
  - "postgres/contrib/isn/isn.c:416"
reproduced: false
---

# `cannot cast %s to %s for number: "%s"`

## What it means

The `isn` extension could not convert one product-number type into another because the source value does not belong to the target type's range. The placeholders are the source type, the target type, and the number. Product-number types share the EAN13 space but each covers a subset of it.

## When it happens

It occurs when casting between `isn` types — for example `isbn` to `issn` — for a value whose prefix does not fall in the destination type's range.

## How to fix

Cast only between compatible `isn` subtypes for a given value, or route through `ean13` when the exact target is uncertain. Confirm the code's prefix matches the destination type before casting.

## Example

*Illustrative* — an incompatible isn cast.

```text
ERROR:  cannot cast issn to isbn for number: "..."
```

## Related

- [cannot cast ean13 to for number](./cannot-cast-ean13-to-for-number.md)
- [cannot coerce to int](./cannot-coerce-to-int.md)
