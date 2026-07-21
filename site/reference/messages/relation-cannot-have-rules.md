---
message: "relation \"%s\" cannot have rules"
slug: relation-cannot-have-rules
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/rewrite/rewriteDefine.c:259"
  - "postgres/src/backend/rewrite/rewriteDefine.c:767"
reproduced: false
---

# `relation "%s" cannot have rules`

## What it means

A `CREATE RULE` targeted a relation kind that does not support rewrite rules. The placeholder is the relation name. Rules can only be attached to plain tables and views, not to relations such as foreign tables, partitioned parents in some cases, or system relations.

## When it happens

It arises from `CREATE RULE ... ON relation` where the relation is of a kind for which rules are not permitted.

## How to fix

Attach the rule to a supported relation (a table or view), or achieve the intended effect another way — triggers for tables, or `INSTEAD OF` triggers/rules on views. For foreign tables, use triggers rather than rules.

## Example

*Illustrative* — creating a rule on an unsupported relation.

```text
ERROR:  relation "remote_orders" cannot have rules
```

## Related

- [rule "%s" for relation "%s" already exists](./rule-for-relation-already-exists.md)
- [relation "%s" is of wrong relation kind](./relation-is-of-wrong-relation-kind.md)
