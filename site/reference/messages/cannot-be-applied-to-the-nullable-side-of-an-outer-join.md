---
message: "%s cannot be applied to the nullable side of an outer join"
slug: cannot-be-applied-to-the-nullable-side-of-an-outer-join
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/optimizer/plan/initsplan.c:2189"
reproduced: false
---

# `%s cannot be applied to the nullable side of an outer join`

## What it means

A locking clause such as `FOR UPDATE` named a table on the nullable side of an outer join — the side whose rows may be null-extended. Locking cannot apply there, because a null-extended row corresponds to no real stored row to lock.

## When it happens

It occurs when `FOR UPDATE OF t` names the table that sits on the outer (nullable) side of a `LEFT`/`RIGHT`/`FULL JOIN`.

## How to fix

Lock only tables on the non-nullable side of the join, or restructure the query so the table you must lock is not outer-joined. Rows that can be null-extended have no lockable counterpart.

## Example

*Illustrative* — locking the outer side.

```sql
SELECT * FROM a LEFT JOIN b USING (id) FOR UPDATE OF b;
```

## Related

- [cannot be applied to a join](./cannot-be-applied-to-a-join.md)
- [cannot be applied to a function](./cannot-be-applied-to-a-function.md)
