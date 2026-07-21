---
message: "operator family \"%s\" of access method %s contains function %s with wrong signature for support number %d"
slug: operator-family-of-access-method-contains-function-with-wrong-signature-for
passthrough: false
api: [ereport]
level: [INFO]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/access/brin/brin_validate.c:125"
  - "postgres/src/backend/access/gin/ginvalidate.c:152"
  - "postgres/src/backend/access/gist/gistvalidate.c:160"
  - "postgres/src/backend/access/hash/hashvalidate.c:122"
  - "postgres/src/backend/access/nbtree/nbtvalidate.c:126"
  - "postgres/src/backend/access/spgist/spgvalidate.c:191"
reproduced: false
---

# `operator family "%s" of access method %s contains function %s with wrong signature for support number %d`

## What it means

Operator-family validation found a support function whose argument or return types do not match what the access method requires for that support number. The placeholders are the operator family, the access method, the function, and the support number. Reported at `INFO` as validation output.

## When it happens

Validating an operator family whose support function has the right support number but the wrong signature — for example a comparison function with the wrong argument types for the indexed data type.

## Is this a problem?

Fix the support function so its signature matches the access method's contract for that support number, then re-register it in the family. This is an opclass definition bug, usually in an extension or hand-built operator class.

## Example

*Illustrative* — a validation notice on a signature mismatch.

```text
INFO:  operator family "my_ops" of access method btree contains function my_cmp with wrong signature for support number 1
```

## Related

- [operator family of access method contains function with invalid support number](./operator-family-of-access-method-contains-function-with-invalid-support-number.md)
- [operator family of access method contains operator with wrong signature](./operator-family-of-access-method-contains-operator-with-wrong-signature.md)
