---
message: "invalid operator number %d, must be between 1 and %d"
slug: invalid-operator-number-must-be-between-1-and
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/opclasscmds.c:492"
  - "postgres/src/backend/commands/opclasscmds.c:928"
  - "postgres/src/backend/commands/opclasscmds.c:1074"
reproduced: false
---

# `invalid operator number %d, must be between 1 and %d`

## What it means

An operator-class or operator-family definition referenced a strategy (operator) number outside the range the access method allows. Each access method defines a fixed set of numbered strategies, and the number given is not one of them.

## When it happens

Running `CREATE OPERATOR CLASS`, `CREATE OPERATOR FAMILY`, or `ALTER OPERATOR FAMILY` with an `OPERATOR n` entry whose number is zero or larger than the count of strategies the access method defines.

## How to fix

Use a strategy number the access method recognizes. Consult the access method's documentation for its strategy numbers, and correct the `OPERATOR n ...` clause to a valid slot.

## Example

*Illustrative* — a strategy number out of range.

```sql
ALTER OPERATOR FAMILY fam USING btree ADD OPERATOR 9 = (int, int);  -- btree has 5 strategies
```

## Related

- [invalid function number must be between 1 and](./invalid-function-number-must-be-between-1-and.md)
- [support function number is invalid for access method](./support-function-number-is-invalid-for-access-method.md)
