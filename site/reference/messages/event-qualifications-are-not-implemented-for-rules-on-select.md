---
message: "event qualifications are not implemented for rules on SELECT"
slug: event-qualifications-are-not-implemented-for-rules-on-select
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteDefine.c:367"
reproduced: false
---

# `event qualifications are not implemented for rules on SELECT`

## What it means

A `CREATE RULE` on a `SELECT` event included a `WHERE` qualification. PostgreSQL only allows unconditional `ON SELECT DO INSTEAD` rules (the mechanism behind views), so a conditional `SELECT` rule is rejected.

## When it happens

It fires from `CREATE RULE ... AS ON SELECT ... WHERE ...`. A `SELECT` rule must be a single unconditional `DO INSTEAD` action, because it defines how the relation is read.

## How to fix

Remove the `WHERE` clause from the `SELECT` rule. If you need conditional read behaviour, put the condition inside the rule's query itself, or define a view whose defining query contains the logic. Conditional rules are only supported for `INSERT`, `UPDATE`, and `DELETE` events.

## Example

*Illustrative* — a qualified SELECT rule is not allowed.

```sql
CREATE RULE r AS ON SELECT TO t WHERE id > 0 DO INSTEAD SELECT * FROM u;
```

## Related

- [expected just one rule action](./expected-just-one-rule-action.md)
- [event trigger "%s" already exists](./event-trigger-already-exists.md)
