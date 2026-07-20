---
message: "array slice subscript must provide both boundaries"
slug: array-slice-subscript-must-provide-both-boundaries
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2889"
reproduced: false
---

# `array slice subscript must provide both boundaries`

## What it means

An array slice used the `[lower:upper]` form but omitted one of the two bounds where both were required, so the slice range is incomplete.

## When it happens

It occurs in certain array-assignment contexts where a slice must have both its lower and upper subscripts specified rather than relying on defaults.

## How to fix

Write both bounds of the slice explicitly, for example `a[2:4]`. In the contexts that raise this, an open-ended slice like `a[2:]` or `a[:4]` is not allowed; supply both the lower and upper subscript.

## Example

*Illustrative* — a slice missing a boundary in an assignment.

```sql
UPDATE t SET a[2:] = '{9,9}';  -- ERROR:  array slice subscript must provide both boundaries
```

## Related

- [arrays must have same bounds](./arrays-must-have-same-bounds.md)
- [array size exceeds the maximum allowed](./array-size-exceeds-the-maximum-allowed-16139a.md)
