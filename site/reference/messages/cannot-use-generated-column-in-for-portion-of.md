---
message: "cannot use generated column \"%s\" in FOR PORTION OF"
slug: cannot-use-generated-column-in-for-portion-of
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/optimizer/plan/planner.c:871"
reproduced: false
---

# `cannot use generated column "%s" in FOR PORTION OF`

## What it means

An `UPDATE ... FOR PORTION OF` used a generated column to define the application-time period. The period bounds must come from stored range columns the statement can split, and a generated column cannot serve that role.

## When it happens

It occurs with temporal `UPDATE ... FOR PORTION OF` when the named period column is a generated column.

## How to fix

Base the period on a plain stored range column rather than a generated one. Restructure the table so the application-time period uses an ordinary column.

## Example

*Illustrative* — a generated column in FOR PORTION OF.

```text
ERROR:  cannot use generated column "valid_at" in FOR PORTION OF
```

## Related

- [cannot update column because it is used in FOR PORTION OF](./cannot-update-column-because-it-is-used-in-for-portion-of.md)
- [cannot use generated column in column generation expression](./cannot-use-generated-column-in-column-generation-expression.md)
