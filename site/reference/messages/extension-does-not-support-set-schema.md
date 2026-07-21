---
message: "extension \"%s\" does not support SET SCHEMA"
slug: extension-does-not-support-set-schema
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/extension.c:3338"
  - "postgres/src/backend/commands/extension.c:3432"
reproduced: false
---

# `extension "%s" does not support SET SCHEMA`

## What it means

An `ALTER EXTENSION ... SET SCHEMA` targeted an extension that cannot be relocated. The `%s` is the extension name. The extension is not marked relocatable, or its members span schemas.

## When it happens

Trying to move a non-relocatable extension to another schema, or one whose objects are not all in a single relocatable schema.

## How to fix

Leave the extension in its current schema. If relocation is essential, check the extension's control file for `relocatable = true`; non-relocatable extensions must be dropped and recreated in the desired schema, if supported.

## Example

*Illustrative* — relocating a non-relocatable extension.

```text
ERROR:  extension "plpgsql" does not support SET SCHEMA
```

## Related

- [extension does not exist](./extension-does-not-exist.md)
- [create specifies a schema different from the one being created](./create-specifies-a-schema-different-from-the-one-being-created.md)
