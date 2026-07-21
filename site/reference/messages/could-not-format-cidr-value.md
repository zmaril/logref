---
message: "could not format cidr value: %m"
slug: could-not-format-cidr-value
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_BINARY_REPRESENTATION
    code: "22P03"
call_sites:
  - "postgres/src/backend/utils/adt/network.c:1183"
reproduced: false
---

# `could not format cidr value: %m`

## What it means

The network type code tried to render a `cidr` value as text and the low-level address formatter failed. The `%m` reason gives the operating-system error. A well-formed `cidr` should always format, so the input bytes are suspect.

## When it happens

It fires while converting an internal `cidr` value to its text form, when the address family or byte length is not one the formatter understands — typically damaged on-disk data or a value built by faulty code.

## How to fix

This is an internal guard. It usually points at a corrupted stored value. Identify the offending row and correct or delete it, and check the storage underneath for faults. If the value came through an extension or custom code, verify how it constructs `cidr` values.

## Example

*Illustrative* — a malformed cidr value that will not format.

```text
ERROR:  could not format cidr value: Address family not supported by protocol
```

## Related

- [could not get element type of array type](./could-not-get-element-type-of-array-type.md)
- [could not identify column in record data type](./could-not-identify-column-in-record-data-type.md)
