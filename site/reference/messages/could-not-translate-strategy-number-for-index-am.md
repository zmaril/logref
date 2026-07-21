---
message: "could not translate strategy number %d for index AM %u"
slug: could-not-translate-strategy-number-for-index-am
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/index/amapi.c:148"
reproduced: false
---

# `could not translate strategy number %d for index AM %u`

## What it means

The server could not translate a strategy number into a comparison type for an index access method. The placeholders are the strategy number and the access-method OID. This is the reverse of the compare-type translation and is likewise an internal mapping.

## When it happens

It fires while the planner or index machinery asks an access method to interpret a strategy number it does not define, which should not occur on built-in access methods.

## How to fix

This is an internal guard. Custom index access methods or operator classes that declare strategies they do not fully implement can reach it; verify their strategy definitions. On stock access methods, capture the query and the access-method OID and report the case.

## Example

*Illustrative* — an untranslatable strategy number.

```text
ERROR:  could not translate strategy number 6 for index AM 403
```

## Related

- [could not translate compare type for index AM](./could-not-translate-compare-type-for-index-am.md)
- [could not retrieve tle for sort-from-groupcols](./could-not-retrieve-tle-for-sort-from-groupcols.md)
