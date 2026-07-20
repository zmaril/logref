---
message: "non-view rule for \"%s\" must not be named \"%s\""
slug: non-view-rule-for-must-not-be-named
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/rewrite/rewriteDefine.c:453"
  - "postgres/src/backend/rewrite/rewriteDefine.c:860"
reproduced: false
---

# `non-view rule for "%s" must not be named "%s"`

## What it means

A rule on a relation was given the name reserved for the automatic view `SELECT` rule (`_RETURN`), but the relation is not a view or the rule is not the view-defining one. That name is reserved. The placeholders are the relation and rule names.

## When it happens

It arises from `CREATE RULE ... AS ON SELECT ... DO INSTEAD` attempts that would name a non-view rule `_RETURN`, or from converting/adding rules in a way that collides with the reserved view rule name.

## How to fix

Do not name ordinary rules `_RETURN`; that name belongs to the view's own `ON SELECT` rule. Use `CREATE VIEW` to define view behavior, and give other rules different names.

## Example

*Illustrative* — a non-view rule using the reserved name.

```sql
CREATE RULE "_RETURN" AS ON SELECT TO t DO INSTEAD ...;  -- reserved for views
```

## Related

- [infinite recursion detected in rules for relation](./infinite-recursion-detected-in-rules-for-relation.md)
- [only WITH CHECK expression allowed for INSERT](./only-with-check-expression-allowed-for-insert.md)
