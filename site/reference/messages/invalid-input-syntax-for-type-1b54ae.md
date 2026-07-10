---
message: "invalid input syntax for type %s: \"%s\""
slug: invalid-input-syntax-for-type-1b54ae
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TEXT_REPRESENTATION
    code: "22P02"
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/numeric.c:8020"
  - "postgres/src/backend/utils/adt/timestamp.c:506"
  - "postgres/src/tutorial/complex.c:39"
reproduced: false
---

# `invalid input syntax for type %s: "%s"`

**Severity:** ERROR · SQLSTATE `22P02` (ERRCODE_INVALID_TEXT_REPRESENTATION), `22023` (ERRCODE_INVALID_PARAMETER_VALUE)

## What it means

A type's input function was handed text it could not parse. The first placeholder is the target type name and the second is the offending literal — so a rendered line reads like `invalid input syntax for type numeric: "12x"`. The value's characters do not form a legal member of that type.

## When it happens

Casting or coercing a string to a type whose syntax it violates: a non-numeric string to `numeric`, a malformed timestamp, a bad literal fed through a `COPY` load, or a client binding the wrong string to a typed parameter. This exact text comes from the `numeric` and timestamp input paths; sibling types word the same idea slightly differently.

## How to fix

Look at the quoted value in the message — it is the raw text that failed. Fix the source of that value: correct the literal, strip stray characters or whitespace, or validate and sanitize input before the cast. For bulk loads, find the offending row (the error context usually names the line) and repair the data or adjust the column type. If the string is legitimate in another format, cast through an intermediate type or use a parsing function such as `to_number` or `to_timestamp` with an explicit format.

## Example

*Illustrative* — a non-numeric string cast to `numeric`.

```sql
SELECT 'zzz'::numeric;
```

Produces:

```text
ERROR:  invalid input syntax for type numeric: "zzz"
```

## Source

This message text is emitted from 3 call sites:

- [`postgres/src/backend/utils/adt/numeric.c:8020`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/numeric.c#L8020) — ERROR
- [`postgres/src/backend/utils/adt/timestamp.c:506`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/timestamp.c#L506) — ERROR
- [`postgres/src/tutorial/complex.c:39`](https://github.com/postgres/postgres/blob/master/src/tutorial/complex.c#L39) — ERROR

## SQLSTATE

- `22P02` — **ERRCODE_INVALID_TEXT_REPRESENTATION**. Class 22 (Data Exception).
- `22023` — **ERRCODE_INVALID_PARAMETER_VALUE**. Class 22 (Data Exception).

## Related

- [date field value out of range](./date-field-value-out-of-range.md)
- [time zone not recognized](./time-zone-not-recognized.md)
