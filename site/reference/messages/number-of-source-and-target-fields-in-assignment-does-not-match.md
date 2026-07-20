---
message: "number of source and target fields in assignment does not match"
slug: number-of-source-and-target-fields-in-assignment-does-not-match
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:7390"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:7424"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:7498"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:7524"
reproduced: false
---

# `number of source and target fields in assignment does not match`

## What it means

A PL/pgSQL multiple-assignment or a row/record assignment had a different number of values on the right than variables (or columns) on the left. Assignment into a list of targets requires the counts to match exactly; a mismatch is ambiguous and rejected. Depending on strictness, over- and under-supply may be treated differently.

## When it happens

`SELECT ... INTO a, b, c` where the query returns a different number of columns, a `(a, b) := (1, 2, 3)` style assignment with mismatched arity, or assigning a row value whose field count differs from the target record's.

## Is this a problem?

Line up the counts: return exactly as many columns as `INTO` targets, or list exactly as many values as variables. If you intended to ignore extra columns, select only the ones you need. For row assignments, make the source and target composite types have the same number of fields.

## Example

*Illustrative* — INTO with the wrong number of targets.

```sql
SELECT 1, 2 INTO a;  -- number of source and target fields does not match
```

## Related

- [cannot return non-composite value from function returning composite type](./cannot-return-non-composite-value-from-function-returning-composite-type.md)
- [function return row and query-specified return row do not match](./function-return-row-and-query-specified-return-row-do-not-match.md)
