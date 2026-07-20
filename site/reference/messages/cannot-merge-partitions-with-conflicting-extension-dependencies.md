---
message: "cannot merge partitions with conflicting extension dependencies"
slug: cannot-merge-partitions-with-conflicting-extension-dependencies
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:23653"
reproduced: false
---

# `cannot merge partitions with conflicting extension dependencies`

## What it means

An `ALTER TABLE ... MERGE PARTITIONS` was blocked because the partitions belong to different extensions, or their extension ownership disagrees. Merging would leave the resulting partition with conflicting extension dependencies, so it is refused.

## When it happens

It occurs when the partitions being merged have different extension-membership records — for example one is owned by an extension and another is not, or they belong to different extensions.

## How to fix

Align the extension ownership of the partitions before merging, or merge partitions that share the same extension dependency. Detach conflicting partitions from their extension where appropriate first.

## Example

*Illustrative* — merging partitions with different extension owners.

```text
ERROR:  cannot merge partitions with conflicting extension dependencies
```

## Related

- [cannot merge partition together with partition](./cannot-merge-partition-together-with-partition.md)
- [cannot move extension into schema because the extension contains the schema](./cannot-move-extension-into-schema-because-the-extension-contains-the-schema.md)
