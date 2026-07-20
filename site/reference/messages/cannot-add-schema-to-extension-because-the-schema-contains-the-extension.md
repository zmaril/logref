---
message: "cannot add schema \"%s\" to extension \"%s\" because the schema contains the extension"
slug: cannot-add-schema-to-extension-because-the-schema-contains-the-extension
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/extension.c:3893"
reproduced: false
---

# `cannot add schema "%s" to extension "%s" because the schema contains the extension`

## What it means

An attempt to make a schema a member of an extension was rejected because that schema already contains the extension. Adding the schema would create a circular ownership between the extension and the schema holding it. The placeholders name the schema and extension.

## When it happens

It occurs during `ALTER EXTENSION ... ADD SCHEMA`, or implicitly while relocating an extension, when the target schema is where the extension itself lives.

## How to fix

Do not add the extension's own schema as a member. Keep the extension in a schema that is not itself tracked as one of its members, or place the objects you want to track in a different schema.

## Example

*Illustrative* — the circular-schema case.

```text
ERROR:  cannot add schema "ext_schema" to extension "myext" because the schema contains the extension
```

## Related

- [cannot add an object of this type to an extension](./cannot-add-an-object-of-this-type-to-an-extension.md)
- [cannot add schema to publication](./cannot-add-schema-to-publication-84c13e.md)
