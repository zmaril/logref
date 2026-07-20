---
message: "rule \"%s\" for relation \"%s\" does not exist"
slug: rule-for-relation-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/rewrite/rewriteDefine.c:706"
  - "postgres/src/backend/rewrite/rewriteDefine.c:832"
  - "postgres/src/backend/rewrite/rewriteSupport.c:106"
reproduced: false
---

# `rule "%s" for relation "%s" does not exist`

## What it means

A command referenced a rewrite rule by name on a relation that has no rule by that name. The rule name must belong to the named relation, and it does not.

## When it happens

Running `ALTER RULE`, `DROP RULE`, or a `COMMENT ON RULE` with a misspelled rule name, a rule already dropped, or a name that belongs to a different relation.

## How to fix

List the relation's rules (`\d+ relname` in psql shows them) and use the exact rule name on the correct relation. Confirm the rule was not removed earlier. Note that the built-in view-backing rule is named `_RETURN`.

## Example

*Illustrative* — dropping a rule that does not exist.

```sql
DROP RULE no_such ON orders;  -- no rule "no_such" on orders
```

## Related

- [trigger for table does not exist](./trigger-for-table-does-not-exist.md)
- [policy for table does not exist](./policy-for-table-does-not-exist.md)
