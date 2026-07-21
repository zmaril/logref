---
message: "operator attribute \"%s\" cannot be changed if it has already been set"
slug: operator-attribute-cannot-be-changed-if-it-has-already-been-set
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/operatorcmds.c:646"
  - "postgres/src/backend/commands/operatorcmds.c:653"
  - "postgres/src/backend/commands/operatorcmds.c:659"
  - "postgres/src/backend/commands/operatorcmds.c:665"
reproduced: false
---

# `operator attribute "%s" cannot be changed if it has already been set`

## What it means

`ALTER OPERATOR` tried to set an operator attribute that already has a value. The placeholder names the attribute. Certain operator optimization attributes — the commutator, negator, and hash/merge join flags — may be filled in once (to complete a mutually referencing pair) but not silently overwritten, because the planner may already have relied on the old value.

## When it happens

Running `ALTER OPERATOR ... SET (COMMUTATOR = ...)` (or `NEGATOR`, `HASHES`, `MERGES`) for an operator where that attribute was already established at `CREATE OPERATOR` time or by an earlier alter.

## How to fix

You cannot change an already-set attribute in place. If it is genuinely wrong, drop and recreate the operator (and anything that depends on it) with the correct attributes. The one supported use of `ALTER OPERATOR ... SET` here is to fill in an attribute that was previously unset, typically to close a commutator/negator loop.

## Example

*Illustrative* — re-setting an already-defined commutator.

```sql
ALTER OPERATOR = (int, int) SET (COMMUTATOR = <>);
```

## Related

- [operator does not exist](./operator-does-not-exist-1d7ffc.md)
- [cannot alter array type](./cannot-alter-array-type.md)
