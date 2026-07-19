---
message: "cannot assign to field %d of expanded record"
slug: cannot-assign-to-field-of-expanded-record
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/expandedrecord.c:1143"
  - "postgres/src/backend/utils/adt/expandedrecord.c:1530"
reproduced: false
---

# `cannot assign to field %d of expanded record`

## What it means

Internal error. PL/pgSQL's expanded-record machinery was asked to assign to a field position that does not exist in the record's current tuple descriptor. The placeholder is the field number. It is a consistency check on the record's internal layout.

## When it happens

It should not occur through ordinary PL/pgSQL. Reaching it points to an inconsistency between a record variable's expected shape and its stored descriptor, not to anything in your assignment statement itself.

## How to fix

Treat it as an internal bug. Capture the PL/pgSQL function and the record's declared type and report it. If a particular record type reproduces it, note whether that type was altered while the function was in use.

## Example

*Illustrative* — emitted internally during a record field assignment.

```text
ERROR:  cannot assign to field 5 of expanded record
```

## Related

- [cannot set generated column](./cannot-set-generated-column.md)
- [could not convert row type](./could-not-convert-row-type.md)
