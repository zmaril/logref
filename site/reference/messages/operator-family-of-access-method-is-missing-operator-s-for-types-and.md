---
message: "operator family \"%s\" of access method %s is missing operator(s) for types %s and %s"
slug: operator-family-of-access-method-is-missing-operator-s-for-types-and
passthrough: false
api: [ereport]
level: [INFO]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/access/brin/brin_validate.c:227"
  - "postgres/src/backend/access/hash/hashvalidate.c:214"
  - "postgres/src/backend/access/nbtree/nbtvalidate.c:230"
  - "postgres/src/backend/access/spgist/spgvalidate.c:270"
reproduced: false
---

# `operator family "%s" of access method %s is missing operator(s) for types %s and %s`

## What it means

Operator-family validation reported that the family lacks required operators for a particular pair of types. The placeholders name the family, access method, and the two types. It is `amvalidate` diagnostic output describing an incomplete cross-type operator set, not a query-time error.

## When it happens

Validating an operator family with cross-type support that does not supply every operator the access method needs for a given type pair — a common gap when adding cross-type comparisons to a btree/hash family.

## Is this a problem?

Add the missing `OPERATOR` entries for the named type pair so the family is complete for that combination. Each access method defines which strategy operators are required; provide them for every type pair the family claims to support, then revalidate.

## Example

*Illustrative* — a cross-type gap flagged by validation.

```text
INFO:  operator family "myfam" of access method btree is missing operator(s) for types integer and bigint
```

## Related

- [operator class of access method is missing operator(s)](./operator-class-of-access-method-is-missing-operator-s.md)
- [operator family of access method contains support function with different left](./operator-family-of-access-method-contains-support-function-with-different-left.md)
