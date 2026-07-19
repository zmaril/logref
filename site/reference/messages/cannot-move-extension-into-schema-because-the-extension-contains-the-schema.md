---
message: "cannot move extension \"%s\" into schema \"%s\" because the extension contains the schema"
slug: cannot-move-extension-into-schema-because-the-extension-contains-the-schema
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/extension.c:3297"
reproduced: false
---

# `cannot move extension "%s" into schema "%s" because the extension contains the schema`

## What it means

An `ALTER EXTENSION ... SET SCHEMA` tried to move an extension into a schema that the extension itself owns. That would make the extension contain its own new home, which is circular, so it is refused. The placeholders are the extension and schema names.

## When it happens

It occurs when the target schema is a member of the extension being moved — the extension created and owns that schema.

## How to fix

Move the extension into a schema it does not contain, or restructure the extension so the schema is not a member. An extension cannot be relocated into one of its own objects.

## Example

*Illustrative* — moving an extension into its own schema.

```text
ERROR:  cannot move extension "my_ext" into schema "my_ext_schema" because the extension contains the schema
```

## Related

- [cannot move an owned sequence into another schema](./cannot-move-an-owned-sequence-into-another-schema.md)
- [cannot merge partitions with conflicting extension dependencies](./cannot-merge-partitions-with-conflicting-extension-dependencies.md)
