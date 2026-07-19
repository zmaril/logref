---
message: "table row type and query-specified row type do not match"
slug: table-row-type-and-query-specified-row-type-do-not-match
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/executor/execExpr.c:665"
  - "postgres/src/backend/executor/execExpr.c:672"
  - "postgres/src/backend/executor/execExpr.c:678"
  - "postgres/src/backend/executor/execExprInterp.c:5511"
  - "postgres/src/backend/executor/execExprInterp.c:5528"
  - "postgres/src/backend/executor/execExprInterp.c:5627"
  - "postgres/src/backend/executor/nodeModifyTable.c:236"
  - "postgres/src/backend/executor/nodeModifyTable.c:255"
  - "postgres/src/backend/executor/nodeModifyTable.c:272"
  - "postgres/src/backend/executor/nodeModifyTable.c:282"
  - "postgres/src/backend/executor/nodeModifyTable.c:292"
reproduced: false
---

# `table row type and query-specified row type do not match`

## What it means

The row shape a query produced does not match the table (or composite type) it is being stored into or compared against — the number, types, or order of columns disagree. Postgres checks that a tuple's structure matches the target row type and rejects a mismatch.

## When it happens

Inserting into a table whose column types were altered out from under a cached plan, a composite-type value that no longer matches its type definition, or a `RETURNING`/trigger path where the row descriptor changed. It often follows an `ALTER TABLE` that changed a column type concurrently.

## How to fix

Ensure the produced row matches the target exactly in column count, order, and type. If it followed an `ALTER TABLE`, re-plan by reconnecting or re-preparing statements so the new row type is used. For composite values, rebuild them against the current type definition. A dropped/added column mid-transaction is a common trigger — retry after the DDL settles.

## Example

*Illustrative* — a cached plan hitting an altered row type.

```text
ERROR:  table row type and query-specified row type do not match
DETAIL:  Table has type integer at ordinal position 2, but query expects text.
```

## Related

- [incorrect number of output arguments](./incorrect-number-of-output-arguments.md)
- [return type must be a row type](./return-type-must-be-a-row-type.md)
