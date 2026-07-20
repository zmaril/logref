---
message: "record \"%s\" has no field \"%s\""
slug: record-has-no-field
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5337"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5510"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5597"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5688"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:6885"
reproduced: false
---

# `record "%s" has no field "%s"`

## What it means

A field access on a composite/record value named a field the record does not have. The placeholders are the record variable and the field name. This most often comes from PL/pgSQL accessing `rec.fieldname` where `fieldname` is not a column of the row the record holds.

## When it happens

In PL/pgSQL, referencing a field on a `RECORD` variable that was assigned a row without that column, or a typo in the field name; also when the record's actual shape differs from what the code assumes.

## How to fix

Use a field name that exists in the record's current row type. If the record is polymorphic (`RECORD`), make sure the query that populated it returns the expected column. Check for typos, and qualify the field with the correct case if the column was created with quoted mixed case.

## Example

*Illustrative* — accessing a field the record does not have.

```text
ERROR:  record "r" has no field "total"
```

## Related

- [column reference is ambiguous](./column-reference-is-ambiguous.md)
- [attribute number not found in view targetlist](./attribute-number-not-found-in-view-targetlist.md)
