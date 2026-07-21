---
message: "cannot mark inherited constraint \"%s\" as %s"
slug: cannot-mark-inherited-constraint-as
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:12766"
reproduced: false
---

# `cannot mark inherited constraint "%s" as %s`

## What it means

An `ALTER TABLE` tried to change a property of a constraint that was inherited from a parent table. Inherited constraints are controlled by the parent, so the child cannot mark one — for example as `NO INHERIT` or `NOT VALID` — on its own. The placeholders are the constraint name and the target property.

## When it happens

It occurs when you run `ALTER TABLE ... ALTER CONSTRAINT` (or a related subcommand) on a child table for a constraint that came down through inheritance.

## How to fix

Change the constraint on the parent table so the change propagates to children, or detach the child from inheritance first if it must carry an independent constraint. Do not set inherited-constraint properties on the child directly.

## Example

*Illustrative* — marking an inherited constraint on the child.

```text
ERROR:  cannot mark inherited constraint "chk_positive" as NO INHERIT
```

## Related

- [cannot have multiple SET ACCESS METHOD subcommands](./cannot-have-multiple-set-access-method-subcommands.md)
- [cannot match partition key to index on column using non-equal operator](./cannot-match-partition-key-to-index-on-column-using-non-equal-operator.md)
