---
message: "column name/value list contains nonexistent column name \"%s\""
slug: column-name-value-list-contains-nonexistent-column-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/pl/tcl/pltcl.c:3316"
reproduced: false
---

# `column name/value list contains nonexistent column name "%s"`

## What it means

A PL/Tcl routine built a column-name/value list (used to construct a tuple) that names a column not present in the target row type. Every name in the list must correspond to a real column.

## When it happens

It happens in PL/Tcl functions using helpers such as `spi_exec` result handling or tuple construction when the supplied name/value list references an unknown column.

## How to fix

Correct the column name in the PL/Tcl list to match the actual row type, or remove the entry. Check for typos and for columns that were renamed or dropped.

## Example

*Illustrative* — a name/value list naming an unknown column.

```text
ERROR:  column name/value list contains nonexistent column name "foo"
```

## Related

- [column name/value list must have even number of elements](./column-name-value-list-must-have-even-number-of-elements.md)
- [column not found in data type](./column-not-found-in-data-type.md)
