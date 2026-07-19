---
message: "argumentless strict functions are pointless"
slug: argumentless-strict-functions-are-pointless
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/jit/llvm/llvmjit_expr.c:691"
reproduced: false
---

# `argumentless strict functions are pointless`

## What it means

A function was defined as `STRICT` (returns NULL on null input) but takes no arguments, which is contradictory: with no arguments there is no null input for strictness to act on.

## When it happens

It occurs in `CREATE FUNCTION` when `STRICT`/`RETURNS NULL ON NULL INPUT` is combined with an empty parameter list.

## How to fix

Remove the `STRICT` marker from a zero-argument function, since it has no effect there. Keep `STRICT` only on functions that take at least one argument.

## Example

*Illustrative* — a STRICT function with no arguments.

```sql
CREATE FUNCTION f() RETURNS int STRICT AS ...;  -- ERROR:  argumentless strict functions are pointless
```

## Related

- [aggregate must have a transition function](./aggregate-must-have-a-transition-function.md)
- [argument name used more than once](./argument-name-used-more-than-once.md)
