---
message: "cannot use system column \"%s\" in MERGE WHEN condition"
slug: cannot-use-system-column-in-merge-when-condition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/parser/parse_relation.c:761"
reproduced: false
---

# `cannot use system column "%s" in MERGE WHEN condition`

## What it means

A `MERGE` statement's `WHEN` condition referenced a system column such as `ctid` or `xmin`. `MERGE` match conditions may use only ordinary columns, so a system-column reference is rejected.

## When it happens

It occurs on `MERGE ... WHEN MATCHED AND (...)` or a similar clause whose condition names a system column.

## How to fix

Rewrite the `WHEN` condition to use user columns only. Remove the system column and express the match on stored data.

## Example

*Illustrative* — a system column in a MERGE condition.

```text
ERROR:  cannot use system column "ctid" in MERGE WHEN condition
```

## Related

- [cannot use system column in column generation expression](./cannot-use-system-column-in-column-generation-expression.md)
- [cannot use system column in publication column list](./cannot-use-system-column-in-publication-column-list.md)
