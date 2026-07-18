---
message: "argument list must have even number of elements"
slug: argument-list-must-have-even-number-of-elements
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/json.c:1203"
  - "postgres/src/backend/utils/adt/jsonb.c:1137"
reproduced: true
---

# `argument list must have even number of elements`

**Severity:** ERROR · SQLSTATE `22023` (ERRCODE_INVALID_PARAMETER_VALUE)

## What it means

A JSON object builder was given an odd number of arguments. Functions like `json_build_object`/`jsonb_build_object` and `json_object` consume arguments in key/value pairs, so the count must be even — every key needs a value.

## When it happens

Calling `jsonb_build_object('a', 1, 'b')` (a trailing key with no value), or a `json_object` text array with an odd length. It usually means an argument was dropped or a pair was half-built in generated SQL.

## How to fix

Supply a value for every key so the argument count is even. If the SQL is generated, check the code that appends key/value pairs for a path that adds a key without its value. When a value can be absent, pass an explicit `NULL` rather than omitting it.

## Example

*Reproduced* — The JSON reproducer scenario builds an object with a lone key (`08_json.sql`).

```sql
SELECT jsonb_build_object('key');
```

Produces:

```text
ERROR:  argument list must have even number of elements
```

## Source

This message text is emitted from 2 call sites:

- [`postgres/src/backend/utils/adt/json.c:1203`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/json.c#L1203) — ERROR
- [`postgres/src/backend/utils/adt/jsonb.c:1137`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/jsonb.c#L1137) — ERROR

## SQLSTATE

- `22023` — **ERRCODE_INVALID_PARAMETER_VALUE**. Class 22 (Data Exception).

## Related

- [invalid input syntax for type](./invalid-input-syntax-for-type-1b54ae.md)
