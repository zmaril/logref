---
message: "cannot SET SCHEMA of extension \"%s\" because other extensions prevent it"
slug: cannot-set-schema-of-extension-because-other-extensions-prevent-it
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/extension.c:3395"
reproduced: false
---

# `cannot SET SCHEMA of extension "%s" because other extensions prevent it`

## What it means

An `ALTER EXTENSION ... SET SCHEMA` was blocked because other extensions depend on the extension's current schema. Moving it would break those dependents, so the move is refused. The placeholder is the extension name.

## When it happens

It occurs when the extension being moved is required by other installed extensions that expect it in its present schema.

## How to fix

Resolve the dependency first: move or drop the dependent extensions, or leave the extension in its current schema. An extension cannot change schema while others rely on its current location.

## Example

*Illustrative* — moving an extension others depend on.

```text
ERROR:  cannot SET SCHEMA of extension "my_ext" because other extensions prevent it
```

## Related

- [cannot move extension into schema because the extension contains the schema](./cannot-move-extension-into-schema-because-the-extension-contains-the-schema.md)
- [cannot merge partitions with conflicting extension dependencies](./cannot-merge-partitions-with-conflicting-extension-dependencies.md)
