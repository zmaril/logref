---
message: "operator family \"%s\" of access method %s contains operator %s with invalid strategy number %d"
slug: operator-family-of-access-method-contains-operator-with-invalid-strategy-number
passthrough: false
api: [ereport]
level: [INFO]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/access/brin/brin_validate.c:147"
  - "postgres/src/backend/access/gin/ginvalidate.c:171"
  - "postgres/src/backend/access/gist/gistvalidate.c:180"
  - "postgres/src/backend/access/hash/hashvalidate.c:148"
  - "postgres/src/backend/access/nbtree/nbtvalidate.c:146"
  - "postgres/src/backend/access/spgist/spgvalidate.c:211"
reproduced: false
---

# `operator family "%s" of access method %s contains operator %s with invalid strategy number %d`

## What it means

Operator-family validation found an operator registered under a strategy number the access method does not define. The placeholders are the operator family, the access method, the operator, and the bad strategy number. Reported at `INFO` as validation output.

## When it happens

Validating an operator family that lists an operator with a strategy number outside the access method's valid set — for example a strategy above 5 for a btree family, which defines only 1 through 5.

## Is this a problem?

Correct the operator family so each operator uses a strategy number the access method defines (`ALTER OPERATOR FAMILY ... DROP/ADD OPERATOR`). This is an opclass definition problem, typically in extension-provided operator classes.

## Example

*Illustrative* — a validation notice on a bad strategy number.

```text
INFO:  operator family "my_ops" of access method btree contains operator my_lt with invalid strategy number 7
```

## Related

- [operator family of access method contains operator with wrong signature](./operator-family-of-access-method-contains-operator-with-wrong-signature.md)
- [operator family of access method contains invalid ORDER BY specification for](./operator-family-of-access-method-contains-invalid-order-by-specification-for.md)
