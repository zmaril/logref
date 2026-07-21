---
message: "name list length must be exactly %d"
slug: name-list-length-must-be-exactly
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:2250"
  - "postgres/src/backend/catalog/objectaddress.c:2267"
  - "postgres/src/backend/catalog/objectaddress.c:2332"
  - "postgres/src/backend/catalog/objectaddress.c:2417"
reproduced: false
---

# `name list length must be exactly %d`

## What it means

An object was referenced by a dotted name whose number of components does not match what the context requires. The placeholder is the required count. Some object addresses (used by `COMMENT`, `SECURITY LABEL`, `ALTER ... DEPENDS ON`, and the object-address functions) demand a name list of an exact length — for example a single unqualified element, or a fixed schema/name/arg triple.

## When it happens

Supplying too few or too many dotted name parts for the object kind — a schema-qualified name where a bare one is required, or vice versa — often through `pg_get_object_address` or a `SECURITY LABEL`/`COMMENT` on an object type with a fixed addressing shape.

## How to fix

Give the name with exactly the number of components the object kind expects. Check the syntax for that object type; for the object-address functions, follow the documented `name`/`args` array shapes for the specific `type` you pass.

## Example

*Illustrative* — a name with the wrong number of parts.

```sql
SELECT pg_get_object_address('role', '{a,b}', '{}');
```

## Related

- [improper relation name (too many dotted names)](./improper-relation-name-too-many-dotted-names.md)
- [unrecognized drop object type](./unrecognized-drop-object-type.md)
