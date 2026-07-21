---
message: "could not find strategy for operator %u in family %u"
slug: could-not-find-strategy-for-operator-in-family
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/relcache.c:5770"
reproduced: false
---

# `could not find strategy for operator %u in family %u`

## What it means

The relation cache tried to map an operator to its strategy number within an operator family and found no match. Strategy numbers are how an index access method names its comparison operators, and the lookup for this operator came up empty.

## When it happens

It fires while building cached index information, when an operator that the catalog claims belongs to a family has no strategy entry there. On stock catalogs this cannot happen; it usually means a hand-edited or corrupted operator family.

## How to fix

This is an internal guard. If it appears, check any custom operator classes or families for missing `OPERATOR` strategy entries, and rebuild them cleanly. A physically damaged catalog would need to be restored from a backup. On stock definitions, capture the operator and family OIDs and report a reproducible case.

## Example

*Illustrative* — an operator with no strategy in its family.

```text
ERROR:  could not find strategy for operator 96 in family 1976
```

## Related

- [could not identify an ordering operator for type](./could-not-identify-an-ordering-operator-for-type.md)
- [could not find tuple for opclass](./could-not-find-tuple-for-opclass.md)
