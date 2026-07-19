---
message: "rule \"%s\" for relation \"%s\" already exists"
slug: rule-for-relation-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/rewrite/rewriteDefine.c:102"
  - "postgres/src/backend/rewrite/rewriteDefine.c:841"
reproduced: false
---

# `rule "%s" for relation "%s" already exists`

## What it means

A `CREATE RULE` named a rule that already exists on the target relation. The placeholders are the rule name and the relation. Rule names must be unique per relation.

## When it happens

It arises when creating a rule whose name is already used on that relation — a re-run migration, or a naming collision.

## How to fix

Use a different rule name, or replace the existing rule with `CREATE OR REPLACE RULE`. Drop the old rule with `DROP RULE name ON relation` first if you intend to redefine it, and guard migrations against re-creating it.

## Example

*Illustrative* — creating a rule that already exists.

```text
ERROR:  rule "_RETURN" for relation "my_view" already exists
```

## Related

- [relation "%s" cannot have rules](./relation-cannot-have-rules.md)
- [trigger "%s" for relation "%s" already exists](./trigger-for-relation-already-exists.md)
