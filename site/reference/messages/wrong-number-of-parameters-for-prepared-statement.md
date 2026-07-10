---
message: "wrong number of parameters for prepared statement \"%s\""
slug: wrong-number-of-parameters-for-prepared-statement
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/prepare.c:295"
reproduced: true
---

# `wrong number of parameters for prepared statement "%s"`

**Severity:** ERROR · SQLSTATE `42601` (ERRCODE_SYNTAX_ERROR)

## What it means

An `EXECUTE` supplied a different number of arguments than the prepared statement declares. A prepared statement fixes its parameter count when it is created; every execution must pass exactly that many. The placeholder names the statement.

## When it happens

`EXECUTE stmt(args)` with too few or too many arguments, or a client driver's parameter array not matching the statement's `$1..$n`. It also appears when a statement is re-prepared with a different signature but the old call shape is reused.

## How to fix

Pass one argument per declared parameter, in order. Check the preparation with `SELECT parameter_types FROM pg_prepared_statements WHERE name = 'stmt'` to see how many the statement expects. In application code, make sure the bound-parameter list length matches the `$1..$n` placeholders in the SQL text.

## Example

*Reproduced* — The transaction/session reproducer scenario over-supplies parameters (`14_txn_session.sql`).

```sql
PREPARE p1 AS SELECT $1::int;
EXECUTE p1(1, 2, 3);
```

Produces:

```text
ERROR:  wrong number of parameters for prepared statement "p1"
```

## Source

Emitted from [`postgres/src/backend/commands/prepare.c:295`](https://github.com/postgres/postgres/blob/master/src/backend/commands/prepare.c#L295).

## SQLSTATE

- `42601` — **ERRCODE_SYNTAX_ERROR**. Class 42 (Syntax Error or Access Rule Violation).

## Related

- [cursor does not exist](./cursor-does-not-exist.md)
