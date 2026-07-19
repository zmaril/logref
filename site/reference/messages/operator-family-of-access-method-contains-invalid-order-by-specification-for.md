---
message: "operator family \"%s\" of access method %s contains invalid ORDER BY specification for operator %s"
slug: operator-family-of-access-method-contains-invalid-order-by-specification-for
passthrough: false
api: [ereport]
level: [INFO]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/access/brin/brin_validate.c:176"
  - "postgres/src/backend/access/gin/ginvalidate.c:184"
  - "postgres/src/backend/access/hash/hashvalidate.c:161"
  - "postgres/src/backend/access/nbtree/nbtvalidate.c:159"
  - "postgres/src/backend/access/spgist/spgvalidate.c:227"
reproduced: false
---

# `operator family "%s" of access method %s contains invalid ORDER BY specification for operator %s`

## What it means

Operator-family validation found an ordering operator whose `ORDER BY` specification is not valid for the access method. The placeholders are the operator family, the access method, and the operator. Reported at `INFO` as validation output for a family that supports ordered scans.

## When it happens

Validating an operator family that declares an ordering (distance) operator — as GiST/SP-GiST families do for nearest-neighbor search — with an `ORDER BY` sort operator or type that the access method does not accept.

## Is this a problem?

Correct the ordering-operator declaration so its `ORDER BY` type/operator matches what the access method requires. This is an opclass definition problem, usually in an extension-provided operator family; report it to the extension author if it is not one you maintain.

## Example

*Illustrative* — a validation notice on an ordering operator.

```text
INFO:  operator family "my_ops" of access method gist contains invalid ORDER BY specification for operator my_dist
```

## Related

- [operator family of access method contains operator with invalid strategy number](./operator-family-of-access-method-contains-operator-with-invalid-strategy-number.md)
- [operator family of access method contains operator with wrong signature](./operator-family-of-access-method-contains-operator-with-wrong-signature.md)
