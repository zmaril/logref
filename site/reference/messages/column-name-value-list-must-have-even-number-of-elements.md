---
message: "column name/value list must have even number of elements"
slug: column-name-value-list-must-have-even-number-of-elements
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/pl/tcl/pltcl.c:3298"
reproduced: false
---

# `column name/value list must have even number of elements`

## What it means

A PL/Tcl column-name/value list had an odd number of items. The list is read as alternating name and value pairs, so it must contain an even count.

## When it happens

It happens in PL/Tcl when constructing a tuple from a flat list and a name is given without its matching value (or vice versa).

## How to fix

Provide a value for every column name so the list has an even length. Check the Tcl list you pass to the tuple-building helper.

## Example

*Illustrative* — an odd-length name/value list.

```text
ERROR:  column name/value list must have even number of elements
```

## Related

- [column name/value list contains nonexistent column name](./column-name-value-list-contains-nonexistent-column-name.md)
- [column number out of range](./column-number-out-of-range.md)
