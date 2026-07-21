---
message: "cannot add NaN to pg_lsn"
slug: cannot-add-nan-to-pg-lsn
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/pg_lsn.c:255"
reproduced: false
---

# `cannot add NaN to pg_lsn`

## What it means

An expression tried to add a `NaN` numeric value to a `pg_lsn`. A log sequence number is a concrete position in the WAL, and adding an undefined `NaN` offset has no meaning.

## When it happens

It occurs when `pg_lsn + numeric` is evaluated and the numeric operand is `NaN`, usually because it came from a computation that produced `NaN`.

## How to fix

Ensure the numeric byte offset added to a `pg_lsn` is a finite number. Guard against `NaN` in the expression that produces the offset, for example by validating inputs before the addition.

## Example

*Illustrative* — adding NaN to an LSN.

```sql
SELECT '0/0'::pg_lsn + 'NaN'::numeric;
```

## Related

- [cannot advance replication slot to minimum is](./cannot-advance-replication-slot-to-minimum-is.md)
- [can only specify a constant, non-aggregate function, or operator expression for](./can-only-specify-a-constant-non-aggregate-function-or-operator-expression-for.md)
