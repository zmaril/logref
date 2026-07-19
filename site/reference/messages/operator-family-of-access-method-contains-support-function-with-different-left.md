---
message: "operator family \"%s\" of access method %s contains support function %s with different left and right input types"
slug: operator-family-of-access-method-contains-support-function-with-different-left
passthrough: false
api: [ereport]
level: [INFO]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/access/gin/ginvalidate.c:81"
  - "postgres/src/backend/access/gist/gistvalidate.c:82"
  - "postgres/src/backend/access/hash/hashvalidate.c:87"
  - "postgres/src/backend/access/spgist/spgvalidate.c:92"
reproduced: false
---

# `operator family "%s" of access method %s contains support function %s with different left and right input types`

## What it means

Operator-family validation reported a support function whose left and right input types differ where the access method expects them to match. The placeholders name the family, access method, and function. It is diagnostic output from `amvalidate` describing a definition problem, not a runtime failure of a query.

## When it happens

Validating an operator family (often during an extension install or `CREATE OPERATOR FAMILY`/`ALTER OPERATOR FAMILY`) that includes a support function registered with mismatched left/right types for a context that requires them to be equal.

## Is this a problem?

Correct the support-function registration so its input types match what the access method requires for that support-function number, or register it for the correct type pair. Consult the access method's support-function contract (for example btree's comparison and sort-support functions) and fix the `FUNCTION n` entry.

## Example

*Illustrative* — a mismatched support function flagged by validation.

```text
INFO:  operator family "myfam" of access method gin contains support function myfunc(int,text) with different left and right input types
```

## Related

- [operator class of access method is missing operator(s)](./operator-class-of-access-method-is-missing-operator-s.md)
- [operator family of access method is missing operator(s) for types and](./operator-family-of-access-method-is-missing-operator-s-for-types-and.md)
