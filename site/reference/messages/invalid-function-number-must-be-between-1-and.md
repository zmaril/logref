---
message: "invalid function number %d, must be between 1 and %d"
slug: invalid-function-number-must-be-between-1-and
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/opclasscmds.c:537"
  - "postgres/src/backend/commands/opclasscmds.c:978"
  - "postgres/src/backend/commands/opclasscmds.c:1090"
reproduced: false
---

# `invalid function number %d, must be between 1 and %d`

## What it means

An operator-class or operator-family definition referenced a support-function number outside the range the access method allows. Each access method defines a fixed set of numbered support functions, and the number given is not one of them.

## When it happens

Running `CREATE OPERATOR CLASS`, `CREATE OPERATOR FAMILY`, or `ALTER OPERATOR FAMILY` with a `FUNCTION n` entry whose number is zero or larger than the count of support functions the access method defines.

## How to fix

Use a support-function number that the access method recognizes. Consult the access method's documentation for its support functions and their numbers, and correct the `FUNCTION n ...` clause to a valid slot.

## Example

*Illustrative* — a support-function number out of range.

```sql
ALTER OPERATOR FAMILY fam USING btree ADD FUNCTION 9 my_cmp(int, int);  -- btree has no function 9
```

## Related

- [invalid operator number must be between 1 and](./invalid-operator-number-must-be-between-1-and.md)
- [support function number is invalid for access method](./support-function-number-is-invalid-for-access-method.md)
