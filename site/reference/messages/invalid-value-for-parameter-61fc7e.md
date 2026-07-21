---
message: "invalid value for parameter \"%s\": %d"
slug: invalid-value-for-parameter-61fc7e
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/regexp.c:715"
  - "postgres/src/backend/utils/adt/regexp.c:724"
  - "postgres/src/backend/utils/adt/regexp.c:1152"
  - "postgres/src/backend/utils/adt/regexp.c:1216"
  - "postgres/src/backend/utils/adt/regexp.c:1225"
  - "postgres/src/backend/utils/adt/regexp.c:1234"
  - "postgres/src/backend/utils/adt/regexp.c:1243"
  - "postgres/src/backend/utils/adt/regexp.c:1923"
  - "postgres/src/backend/utils/adt/regexp.c:1932"
  - "postgres/src/backend/utils/adt/regexp.c:1941"
reproduced: false
---

# `invalid value for parameter "%s": %d`

## What it means

A function or option parameter was given a numeric value outside its accepted range. The first placeholder is the parameter name, the second the bad numeric value. This form (with a `%d` value) is used, for example, by regex functions validating a flag or count argument.

## When it happens

Passing an out-of-range integer to a parameter — for instance a negative or too-large occurrence/subexpression number to a `regexp_*` function, or a numeric option beyond its allowed bounds.

## How to fix

Supply a value within the parameter's valid range; the message names the parameter so you know which argument to fix. Check the function's documentation for the accepted range (for example a subexpression index must be within the number of capture groups). Validate the value before the call.

## Example

*Illustrative* — an out-of-range regex argument.

```sql
SELECT regexp_substr('abc', '(a)(b)', 1, 1, '', 5);
```

Produces:

```text
ERROR:  invalid value for parameter "n": 5
```

## Related

- [invalid value for parameter](./invalid-value-for-parameter-821f2c.md)
- [%s requires a numeric value](./requires-a-numeric-value.md)
