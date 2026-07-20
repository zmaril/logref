---
message: "cannot set generated column \"%s\""
slug: cannot-set-generated-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_E_R_I_E_TRIGGER_PROTOCOL_VIOLATED
    code: "39P01"
call_sites:
  - "postgres/src/pl/plpython/plpy_exec.c:1087"
  - "postgres/src/pl/tcl/pltcl.c:3329"
reproduced: false
---

# `cannot set generated column "%s"`

## What it means

A PL/Python or PL/Tcl trigger function tried to assign a value to a generated column in the row it returns. The placeholder is the column name. A generated column's value is always computed from its expression, so a trigger cannot set it.

## When it happens

A `BEFORE` trigger written in PL/Python or PL/Tcl that includes a generated column among the fields it sets in the returned row.

## How to fix

Remove the generated column from the fields the trigger assigns; leave its value to the generation expression. Set only ordinary columns in the returned row, and let Postgres compute the generated ones.

## Example

*Illustrative* — a trigger setting a generated column.

```text
ERROR:  cannot set generated column "total"
```

## Related

- [cannot insert a non-DEFAULT value into column](./cannot-insert-a-non-default-value-into-column.md)
- [cannot set system attribute](./cannot-set-system-attribute.md)
