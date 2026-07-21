---
message: "could not coerce FOR PORTION OF target from %s to %s"
slug: could-not-coerce-for-portion-of-target-from-to
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/analyze.c:1399"
reproduced: false
---

# `could not coerce FOR PORTION OF target from %s to %s`

## What it means

An `UPDATE ... FOR PORTION OF` or `DELETE ... FOR PORTION OF` statement referenced a temporal target whose bound type could not be cast to the type the portion clause requires. The two types are incompatible.

## When it happens

It happens when parsing a `FOR PORTION OF` clause against a table whose period or range column type does not match the values supplied in the portion bounds.

## How to fix

Supply portion bounds whose type matches the table's temporal column, or cast them explicitly. Check that the range or period column and the `FROM`/`TO` values share a compatible type.

## Example

*Illustrative* — a portion bound that cannot be coerced to the target type.

```sql
UPDATE t FOR PORTION OF valid_at FROM 'abc' TO 'def' SET x = 1;
-- ERROR:  could not coerce FOR PORTION OF target from text to daterange
```

## Related

- [could not convert type to](./could-not-convert-type-to.md)
- [could not determine which collation to use for view column](./could-not-determine-which-collation-to-use-for-view-column.md)
