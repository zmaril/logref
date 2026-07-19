---
message: "could not find tuple for opclass %u"
slug: could-not-find-tuple-for-opclass
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/relcache.c:1759"
reproduced: false
---

# `could not find tuple for opclass %u`

## What it means

The relation cache looked up an operator class row by its identifier while building cached index information and did not find it. Index metadata needs the `pg_opclass` row to know how to compare and hash the indexed values.

## When it happens

It fires while opening an index whose declared operator class has no catalog row — for example an operator class dropped out from under an index, or a damaged catalog.

## How to fix

This is an internal guard. Make sure custom operator classes are not dropped while indexes still use them. If a catalog inconsistency is the cause, restoring from a backup is the reliable fix; capture the opclass OID and report a reproducible case if it appears on stable definitions.

## Example

*Illustrative* — a missing operator-class row while opening an index.

```text
ERROR:  could not find tuple for opclass 10042
```

## Related

- [could not find strategy for operator in family](./could-not-find-strategy-for-operator-in-family.md)
- [could not identify an ordering operator for type](./could-not-identify-an-ordering-operator-for-type.md)
