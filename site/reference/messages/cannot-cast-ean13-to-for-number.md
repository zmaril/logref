---
message: "cannot cast EAN13(%s) to %s for number: \"%s\""
slug: cannot-cast-ean13-to-for-number
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TEXT_REPRESENTATION
    code: "22P02"
call_sites:
  - "postgres/contrib/isn/isn.c:409"
reproduced: false
---

# `cannot cast EAN13(%s) to %s for number: "%s"`

## What it means

The `isn` extension could not convert an EAN13 value into the requested narrower product-number type because the EAN13 does not fit that type's numbering space. EAN13 is the widest code; only values within a subtype's range can be cast to it. The placeholders are the source value, the target type, and the number.

## When it happens

It occurs when casting an `ean13` to a narrower type such as `isbn`, `issn`, or `upc` for a value that lies outside that subtype's assigned prefix range.

## How to fix

Only cast EAN13 values whose prefix belongs to the target subtype. Keep values that do not fit as `ean13`, or verify the code's prefix before casting to a narrower `isn` type.

## Example

*Illustrative* — an out-of-range EAN13 cast.

```text
ERROR:  cannot cast EAN13(978...) to isbn13 for number: "..."
```

## Related

- [cannot cast to for number](./cannot-cast-to-for-number.md)
- [cannot cast xmlserialize result to](./cannot-cast-xmlserialize-result-to.md)
