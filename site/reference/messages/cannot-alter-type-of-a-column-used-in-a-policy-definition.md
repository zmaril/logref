---
message: "cannot alter type of a column used in a policy definition"
slug: cannot-alter-type-of-a-column-used-in-a-policy-definition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:15718"
reproduced: false
---

# `cannot alter type of a column used in a policy definition`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... TYPE` was blocked because a row-level security policy references the column. The policy's `USING` or `WITH CHECK` expression depends on the column's type.

## When it happens

It occurs when the column being retyped appears in a row-security policy expression on the table.

## How to fix

Drop the policy, alter the column type, then recreate the policy against the new type. Confirm the policy expression still type-checks after the change.

## Example

*Illustrative* — a column used in a policy.

```text
ERROR:  cannot alter type of a column used in a policy definition
```

## Related

- [cannot alter type of a column used in a trigger definition](./cannot-alter-type-of-a-column-used-in-a-trigger-definition.md)
- [cannot alter type of a column used by a view or rule](./cannot-alter-type-of-a-column-used-by-a-view-or-rule.md)
