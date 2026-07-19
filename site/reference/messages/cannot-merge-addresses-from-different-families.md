---
message: "cannot merge addresses from different families"
slug: cannot-merge-addresses-from-different-families
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/network.c:1416"
reproduced: false
---

# `cannot merge addresses from different families`

## What it means

A network function was asked to combine an IPv4 address with an IPv6 address. The `inet`/`cidr` types cannot merge addresses that belong to different address families, so the operation is rejected.

## When it happens

It occurs when a function such as `inet_merge()` receives one IPv4 and one IPv6 argument, or when a set being aggregated mixes the two families.

## How to fix

Operate on addresses of a single family. Filter or convert the values so both are IPv4 or both are IPv6 before merging, and handle the two families separately where a data set contains both.

## Example

*Illustrative* — merging IPv4 with IPv6.

```text
ERROR:  cannot merge addresses from different families
```

## Related

- [cannot merge incompatible arrays](./cannot-merge-incompatible-arrays.md)
- [cannot format salt string](./cannot-format-salt-string.md)
