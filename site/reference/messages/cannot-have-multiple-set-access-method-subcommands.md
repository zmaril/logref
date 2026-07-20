---
message: "cannot have multiple SET ACCESS METHOD subcommands"
slug: cannot-have-multiple-set-access-method-subcommands
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:5265"
reproduced: false
---

# `cannot have multiple SET ACCESS METHOD subcommands`

## What it means

A single `ALTER TABLE` statement contained more than one `SET ACCESS METHOD` subcommand. A table has one access method, so the statement may set it only once.

## When it happens

It occurs when an `ALTER TABLE` combines several `SET ACCESS METHOD` clauses in one statement.

## How to fix

Specify `SET ACCESS METHOD` only once per `ALTER TABLE`. Choose the single target access method you want and give it in one subcommand.

## Example

*Illustrative* — two SET ACCESS METHOD clauses.

```text
ERROR:  cannot have multiple SET ACCESS METHOD subcommands
```

## Related

- [cannot have multiple SET TABLESPACE subcommands](./cannot-have-multiple-set-tablespace-subcommands.md)
- [cannot mark inherited constraint as](./cannot-mark-inherited-constraint-as.md)
