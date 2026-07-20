---
message: "only WITH CHECK expression allowed for INSERT"
slug: only-with-check-expression-allowed-for-insert
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/policy.c:622"
  - "postgres/src/backend/commands/policy.c:925"
reproduced: false
---

# `only WITH CHECK expression allowed for INSERT`

## What it means

A row-level security policy attached a `USING` expression to an `INSERT` action, but `INSERT` policies accept only a `WITH CHECK` expression. `INSERT` has no existing rows to filter with `USING`.

## When it happens

It arises from `CREATE POLICY ... FOR INSERT USING (...)` — the `USING` clause is not valid for `INSERT`, which validates new rows via `WITH CHECK`.

## How to fix

Use `WITH CHECK (...)` for `INSERT` policies to validate the incoming row. Reserve `USING (...)` for actions that read existing rows (`SELECT`, `UPDATE`, `DELETE`). For `UPDATE` you may specify both.

## Example

*Illustrative* — a USING clause on an INSERT policy.

```sql
CREATE POLICY p ON t FOR INSERT USING (owner = current_user);  -- use WITH CHECK
```

## Related

- [is not allowed in ON CONFLICT clause](./is-not-allowed-in-on-conflict-clause.md)
- [ON CONFLICT DO SELECT requires a RETURNING clause](./on-conflict-do-select-requires-a-returning-clause.md)
