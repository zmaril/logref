---
message: "cannot AND inet values of different sizes"
slug: cannot-and-inet-values-of-different-sizes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/network.c:1824"
reproduced: true
---

# `cannot AND inet values of different sizes`

## What it means

A bitwise `AND` was applied to two network addresses of different families — for example an IPv4 value and an IPv6 value. The `&` operator on `inet` requires both operands to be the same address size.

## When it happens

It occurs when combining an IPv4 and an IPv6 `inet` value with the bitwise `&` operator.

## How to fix

Operate on addresses of the same family. Convert or restrict the values so both sides are IPv4 or both are IPv6 before applying the bitwise operator.

## Example

*Reproduced* — captured from `reproducers/scenarios/20_network_geo_enum_ts_xml.sql`.

```sql
SELECT '1.2.3.4'::inet & '::1'::inet;
```

Produces:

```text
ERROR:  cannot AND inet values of different sizes
```

## Related

- [cannot and bit strings of different sizes](./cannot-and-bit-strings-of-different-sizes.md)
- [cannot coerce to int](./cannot-coerce-to-int.md)
