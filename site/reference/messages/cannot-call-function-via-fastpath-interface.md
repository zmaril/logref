---
message: "cannot call function \"%s\" via fastpath interface"
slug: cannot-call-function-via-fastpath-interface
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/tcop/fastpath.c:146"
reproduced: false
---

# `cannot call function "%s" via fastpath interface`

## What it means

A client used the protocol-level fast-path function-call interface to invoke a function that is not allowed through that path. The fast-path interface bypasses the normal parser and planner, so it only permits a restricted set of simple functions.

## When it happens

It occurs when a driver or application issues a fast-path call for a function that requires full query processing, such as one with complex argument handling or set-returning behavior.

## How to fix

Call the function through an ordinary SQL statement instead of the fast-path interface. Most client libraries offer a normal query path; reserve fast-path calls for the simple functions it supports, such as large-object operations.

## Example

*Illustrative* — a disallowed fast-path call.

```text
ERROR:  cannot call function "f" via fastpath interface
```

## Related

- [cannot call on a non-object](./cannot-call-on-a-non-object.md)
- [cannot be executed from a function or procedure](./cannot-be-executed-from-a-function-or-procedure.md)
