---
message: "operator class \"%s\" of access method %s is missing operator(s)"
slug: operator-class-of-access-method-is-missing-operator-s
passthrough: false
api: [ereport]
level: [INFO]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/access/brin/brin_validate.c:250"
  - "postgres/src/backend/access/hash/hashvalidate.c:228"
  - "postgres/src/backend/access/nbtree/nbtvalidate.c:254"
  - "postgres/src/backend/access/spgist/spgvalidate.c:305"
reproduced: false
---

# `operator class "%s" of access method %s is missing operator(s)`

## What it means

An operator-class validation check (run by `amvalidate`, typically during `CREATE OPERATOR CLASS` or an extension install) reported that the operator class does not provide all the operators its access method requires. The placeholders name the operator class and access method. At this call site it is informational — it enumerates what is missing so the definition can be corrected.

## When it happens

Defining or validating an operator class (often from an extension) whose set of `OPERATOR` entries is incomplete for the access method — for example a btree opclass missing one of the five comparison operators.

## Is this a problem?

Add the missing operators to the operator-class definition. Each access method documents the operator strategy numbers it needs (btree needs `<`, `<=`, `=`, `>=`, `>`; hash needs `=`; and so on). Supply an `OPERATOR n <op>` entry for each required strategy, then revalidate.

## Example

*Illustrative* — an incomplete operator class flagged by validation.

```text
INFO:  operator class "myops" of access method btree is missing operator(s)
```

## Related

- [operator family of access method is missing operator(s) for types and](./operator-family-of-access-method-is-missing-operator-s-for-types-and.md)
- [operator family of access method contains support function with different left](./operator-family-of-access-method-contains-support-function-with-different-left.md)
