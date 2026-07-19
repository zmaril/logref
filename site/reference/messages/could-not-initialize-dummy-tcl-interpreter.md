---
message: "could not initialize dummy Tcl interpreter"
slug: could-not-initialize-dummy-tcl-interpreter
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/tcl/pltcl.c:446"
reproduced: false
---

# `could not initialize dummy Tcl interpreter`

## What it means

PL/Tcl tried to create a throwaway Tcl interpreter used during setup and Tcl reported failure. This dummy interpreter is used briefly while the language handler configures itself.

## When it happens

It fires while PL/Tcl initializes, when the temporary interpreter cannot be created — usually a problem in the Tcl library the server is linked against.

## How to fix

This is an internal guard around the Tcl runtime. Confirm the Tcl library PL/Tcl was built against is present and healthy. Reinstalling or fixing the Tcl installation resolves it; if it recurs on a working Tcl, capture the log and report it.

## Example

*Illustrative* — the setup Tcl interpreter could not be created.

```text
ERROR:  could not initialize dummy Tcl interpreter
```

## Related

- [could not initialize PLy_CursorType](./could-not-initialize-ply-cursortype.md)
- [could not initialize xml library](./could-not-initialize-xml-library.md)
