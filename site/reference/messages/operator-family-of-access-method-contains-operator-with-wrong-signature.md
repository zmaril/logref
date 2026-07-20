---
message: "operator family \"%s\" of access method %s contains operator %s with wrong signature"
slug: operator-family-of-access-method-contains-operator-with-wrong-signature
passthrough: false
api: [ereport]
level: [INFO]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/access/brin/brin_validate.c:189"
  - "postgres/src/backend/access/gin/ginvalidate.c:197"
  - "postgres/src/backend/access/gist/gistvalidate.c:228"
  - "postgres/src/backend/access/hash/hashvalidate.c:174"
  - "postgres/src/backend/access/nbtree/nbtvalidate.c:172"
  - "postgres/src/backend/access/spgist/spgvalidate.c:243"
reproduced: false
---

# `operator family "%s" of access method %s contains operator %s with wrong signature`

## What it means

Operator-family validation found an operator whose input types do not match what the access method expects for its strategy. The placeholders are the operator family, the access method, and the operator. Reported at `INFO` as validation output.

## When it happens

Validating an operator family whose member operator has the right strategy number but operand types inconsistent with the indexed type or the family's declared type pairs.

## Is this a problem?

Fix the operator's signature or its registration in the family so the operand types match the access method's contract. This is an opclass definition bug, usually in an extension or hand-built family.

## Example

*Illustrative* — a validation notice on an operator signature.

```text
INFO:  operator family "my_ops" of access method btree contains operator my_lt with wrong signature
```

## Related

- [operator family of access method contains operator with invalid strategy number](./operator-family-of-access-method-contains-operator-with-invalid-strategy-number.md)
- [operator family of access method contains function with wrong signature for support number](./operator-family-of-access-method-contains-function-with-wrong-signature-for.md)
