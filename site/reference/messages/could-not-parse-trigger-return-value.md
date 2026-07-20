---
message: "could not parse trigger return value: %s"
slug: could-not-parse-trigger-return-value
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_E_R_I_E_TRIGGER_PROTOCOL_VIOLATED
    code: "39P01"
call_sites:
  - "postgres/src/pl/tcl/pltcl.c:1304"
reproduced: false
---

# `could not parse trigger return value: %s`

## What it means

A PL/Tcl trigger function returned a value the language handler could not interpret as a trigger result. The `%s` value gives the detail. A trigger must return a row value or a recognized keyword, and this return did not match.

## When it happens

It happens when a PL/Tcl trigger returns something other than a valid trigger result — for example a malformed row list, or a value that does not convert to the table's column types.

## How to fix

Return a value the trigger protocol allows: the standard `OK`/`SKIP` keywords, or a properly formed name/value list representing the modified row. Correct the trigger function's return statement to match what a trigger must produce.

## Example

*Illustrative* — a trigger return value that could not be parsed.

```text
ERROR:  could not parse trigger return value: list must have an even number of elements
```

## Related

- [could not parse function return value](./could-not-parse-function-return-value.md)
- [could not re-fetch previously fetched frame row](./could-not-re-fetch-previously-fetched-frame-row.md)
