---
message: "incomplete scalar array"
slug: incomplete-scalar-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/readfuncs.c:685"
  - "postgres/src/backend/nodes/readfuncs.c:690"
reproduced: false
---

# `incomplete scalar array`

## What it means

Internal error. Node deserialization (`readfuncs`) hit a truncated scalar array while reading a stored node tree. It is a parse-consistency guard for serialized nodes.

## When it happens

It fires when reading a node tree whose serialized array data is incomplete — a corrupted stored rule/view or a version mismatch. Ordinary queries do not surface it.

## How to fix

This is a can't-happen guard for well-formed input. If it involves a stored rule/view or a cross-version artifact, suspect catalog damage or a mismatched dump, and report a reproducible case.

## Example

*Illustrative* — a truncated scalar array during node read.

```text
ERROR:  incomplete scalar array
```

## Related

- [incomplete Bitmapset structure](./incomplete-bitmapset-structure.md)
- [incomplete GUC state](./incomplete-guc-state.md)
