---
message: "cannot set system attribute \"%s\""
slug: cannot-set-system-attribute
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/pl/plpython/plpy_exec.c:1082"
  - "postgres/src/pl/tcl/pltcl.c:3323"
reproduced: false
---

# `cannot set system attribute "%s"`

## What it means

A PL/Python or PL/Tcl trigger function tried to assign a value to a system attribute (such as `ctid` or `xmin`) in the row it returns. The placeholder is the attribute name. System columns are managed by Postgres and cannot be set by a trigger.

## When it happens

A trigger written in PL/Python or PL/Tcl that includes a system column among the fields it sets in the returned row.

## How to fix

Set only ordinary user columns in the trigger's returned row. Remove any system-column assignment; those values are maintained by the system and are not writable.

## Example

*Illustrative* — a trigger setting a system attribute.

```text
ERROR:  cannot set system attribute "ctid"
```

## Related

- [cannot set generated column](./cannot-set-generated-column.md)
- [cannot add not-null constraint on system column](./cannot-add-not-null-constraint-on-system-column.md)
