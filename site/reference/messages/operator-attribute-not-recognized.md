---
message: "operator attribute \"%s\" not recognized"
slug: operator-attribute-not-recognized
passthrough: false
api: [ereport]
level: [ERROR, WARNING]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/operatorcmds.c:152"
  - "postgres/src/backend/commands/operatorcmds.c:585"
reproduced: false
---

# `operator attribute "%s" not recognized`

## What it means

A `CREATE OPERATOR` clause named an attribute the parser does not recognize. The placeholder is the offending attribute name. Operators accept a fixed set of attributes.

## When it happens

It arises from `CREATE OPERATOR name (...)` when the definition includes an unknown keyword in place of a valid attribute such as `PROCEDURE`/`FUNCTION`, `LEFTARG`, `RIGHTARG`, `COMMUTATOR`, `NEGATOR`, `RESTRICT`, `JOIN`, `HASHES`, or `MERGES`.

## How to fix

Use only the recognized operator attributes. Correct the misspelled or unsupported keyword, and consult the `CREATE OPERATOR` documentation for the complete list of valid attributes.

## Example

*Illustrative* — an unknown operator attribute.

```sql
CREATE OPERATOR === (LEFTARG=int, RIGHTARG=int, FUNC=f);  -- 'FUNC' not recognized (use FUNCTION)
```

## Related

- [operator cannot be its own negator](./operator-cannot-be-its-own-negator.md)
- [is not a valid operator name](./is-not-a-valid-operator-name.md)
