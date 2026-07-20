---
message: "could not create internal procedure \"%s\": %s"
slug: could-not-create-internal-procedure
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_EXTERNAL_ROUTINE_EXCEPTION
    code: "38000"
call_sites:
  - "postgres/src/pl/tcl/pltcl.c:1788"
reproduced: false
---

# `could not create internal procedure "%s": %s`

## What it means

PL/Tcl could not register an internal Tcl procedure it builds to wrap a user function's body. The `%s` gives the Tcl error. This happens while PL/Tcl compiles a function for execution.

## When it happens

It happens the first time a PL/Tcl function runs in a session, when defining its wrapper procedure in the Tcl interpreter fails — usually because the function body is not valid Tcl.

## How to fix

Check the PL/Tcl function's body for Tcl syntax errors. The attached Tcl error message points at the problem in the code. Fix the function definition and retry.

## Example

*Illustrative* — a PL/Tcl body that fails to compile.

```text
ERROR:  could not create internal procedure "__PLTcl_proc_1234": ...tcl error...
```

## Related

- [could not create dummy Tcl interpreter](./could-not-create-dummy-tcl-interpreter.md)
- [could not create subsidiary Tcl interpreter](./could-not-create-subsidiary-tcl-interpreter.md)
