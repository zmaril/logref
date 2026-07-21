---
message: "operator family \"%s\" of access method %s contains function %s with invalid support number %d"
slug: operator-family-of-access-method-contains-function-with-invalid-support-number
passthrough: false
api: [ereport]
level: [INFO]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/access/brin/brin_validate.c:109"
  - "postgres/src/backend/access/gin/ginvalidate.c:140"
  - "postgres/src/backend/access/gist/gistvalidate.c:148"
  - "postgres/src/backend/access/hash/hashvalidate.c:110"
  - "postgres/src/backend/access/nbtree/nbtvalidate.c:114"
  - "postgres/src/backend/access/spgist/spgvalidate.c:179"
reproduced: false
---

# `operator family "%s" of access method %s contains function %s with invalid support number %d`

## What it means

Operator-family validation found a support function registered under a support number that the access method does not define. The placeholders are the operator family, the access method, the function, and the bad support number. This is diagnostic output from validating an operator family, reported at `INFO`.

## When it happens

Running access-method validation over an operator family — during `CREATE OPERATOR CLASS`/`ALTER OPERATOR FAMILY`, or an `amcheck`-style validation — when the family lists a support function with a number outside the access method's valid range.

## Is this a problem?

This is an operator-family definition problem, almost always in extension-provided or hand-built opclasses. Correct the family so each support function uses a support number the access method defines (`ALTER OPERATOR FAMILY ... DROP/ADD FUNCTION`). If it comes from an extension, report it to the author.

## Example

*Illustrative* — a validation notice on a bad support number.

```text
INFO:  operator family "my_ops" of access method btree contains function my_cmp with invalid support number 9
```

## Related

- [operator family of access method contains function with wrong signature for support number](./operator-family-of-access-method-contains-function-with-wrong-signature-for.md)
- [operator family of access method contains operator with invalid strategy number](./operator-family-of-access-method-contains-operator-with-invalid-strategy-number.md)
