---
message: "invalid mask length: %d"
slug: invalid-mask-length
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/network.c:330"
  - "postgres/src/backend/utils/adt/network.c:353"
reproduced: true
---

# `invalid mask length: %d`

## What it means

A network-mask length passed to an inet/cidr function is outside the range valid for the address family. IPv4 masks run `0..32` and IPv6 masks run `0..128`; the placeholder shows the rejected length.

## When it happens

It arises from functions like `set_masklen(inet, int)` or `network()` helpers when the requested prefix length exceeds the address family's maximum or is negative.

## How to fix

Pass a mask length within the valid range for the address: `0..32` for IPv4 and `0..128` for IPv6. Check whether the value is being applied to the family you think it is.

## Example

*Reproduced* — captured from `reproducers/scenarios/20_network_geo_enum_ts_xml.sql`.

```sql
SELECT set_masklen('::1'::inet, 200);
```

Produces:

```text
ERROR:  invalid mask length: 200
```

## Related

- [invalid value for integer option](./invalid-value-for-integer-option.md)
- [number is out of range](./number-is-out-of-range.md)
