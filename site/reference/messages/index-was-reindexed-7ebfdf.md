---
message: "index \"%s.%s\" was reindexed"
slug: index-was-reindexed-7ebfdf
passthrough: false
api: [ereport]
level: [INFO]
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:4560"
  - "postgres/src/backend/commands/indexcmds.c:4572"
reproduced: false
---

# `index "%s.%s" was reindexed`

## What it means

An informational message that a named index was rebuilt, reported after a reindex step completed.

## When it happens

It arises from `REINDEX` (and reindex-driving tools such as `reindexdb`) reporting each index it rebuilt.

## Is this a problem?

No action is needed. It confirms a successful reindex. It is useful for tracking which indexes a bulk reindex touched.

## Example

*Illustrative* — an index rebuilt.

```text
INFO:  index "public.orders_pkey" was reindexed
```

## Related

- [executing %s](./executing-ddcf88.md)
- [finished item %d %s %s](./finished-item.md)
