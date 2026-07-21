---
message: "could not translate compare type %u for index AM %u"
slug: could-not-translate-compare-type-for-index-am
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/index/amapi.c:178"
reproduced: false
---

# `could not translate compare type %u for index AM %u`

## What it means

The server could not translate a comparison type into a strategy number for an index access method. The placeholders are the compare type and the access-method OID. Comparison types are an abstract way to name orderings; the access method could not map this one.

## When it happens

It fires when planning or building an index and the access method is asked to translate a compare type it does not define. On stock access methods this does not happen; a custom or misconfigured access method can trigger it.

## How to fix

This is an internal guard. If you are using a custom index access method or operator class, check that it defines the strategies for the comparison types it claims to support. On built-in access methods, capture the query and the access-method OID and report it.

## Example

*Illustrative* — an unmappable compare type.

```text
ERROR:  could not translate compare type 5 for index AM 403
```

## Related

- [could not translate strategy number for index AM](./could-not-translate-strategy-number-for-index-am.md)
- [could not retrieve tle for sort-from-groupcols](./could-not-retrieve-tle-for-sort-from-groupcols.md)
