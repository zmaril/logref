---
message: "could not parse function return value: %s"
slug: could-not-parse-function-return-value
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_EXTERNAL_ROUTINE_EXCEPTION
    code: "38000"
call_sites:
  - "postgres/src/pl/tcl/pltcl.c:1038"
reproduced: false
---

# `could not parse function return value: %s`

## What it means

PL/Tcl ran a function that returns a composite or set result and could not parse the Tcl value it returned into the expected type. The `%s` value gives the detail. The returned Tcl list did not match the function's declared result.

## When it happens

It happens when a PL/Tcl function returns a value whose structure does not fit its declared return type — for example a malformed name/value list for a composite result, or a value that does not convert to the column types.

## How to fix

Return a Tcl value that matches the function's result type: a proper name/value list for a composite type, with each value convertible to its column type. Correct the return statement in the function body to match the declared type.

## Example

*Illustrative* — a return value that does not fit the result type.

```text
ERROR:  could not parse function return value: list must have an even number of elements
```

## Related

- [could not parse trigger return value](./could-not-parse-trigger-return-value.md)
- [could not parse salt options](./could-not-parse-salt-options.md)
