---
message: "operator family \"%s\" of access method %s is missing cross-type operator(s)"
slug: operator-family-of-access-method-is-missing-cross-type-operator-s
passthrough: false
api: [ereport]
level: [INFO]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/access/hash/hashvalidate.c:244"
  - "postgres/src/backend/access/nbtree/nbtvalidate.c:270"
reproduced: false
---

# `operator family "%s" of access method %s is missing cross-type operator(s)`

## What it means

An informational validation notice that an operator family for an access method lacks one or more cross-type operators that a complete family would provide.

## When it happens

It arises from operator-class/family validation (for example `amvalidate` during `CREATE OPERATOR CLASS`/extension install) when the family does not define every cross-type operator combination.

## Is this a problem?

Often intentional and harmless — many families omit cross-type operators deliberately. If cross-type comparisons must be indexable, add the missing operators to the family; otherwise the notice can be left as-is.

## Example

*Illustrative* — a family missing cross-type operators.

```text
INFO:  operator family "integer_ops" of access method btree is missing cross-type operator(s)
```

## Related

- [collation "%s" already exists, skipping](./collation-already-exists-skipping.md)
- [publication parameters are not applicable to sequence synchronization and will be ignored for sequences](./publication-parameters-are-not-applicable-to-sequence-synchronization-and-will.md)
