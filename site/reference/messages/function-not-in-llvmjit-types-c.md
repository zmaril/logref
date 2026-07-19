---
message: "function %s not in llvmjit_types.c"
slug: function-not-in-llvmjit-types-c
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/jit/llvm/llvmjit.c:450"
  - "postgres/src/backend/jit/llvm/llvmjit.c:478"
reproduced: false
---

# `function %s not in llvmjit_types.c`

## What it means

Internal error in the JIT engine. Generated code referenced a function that is not registered in the JIT's known-types table (`llvmjit_types.c`). The `%s` is the function name. It is a JIT-build guard.

## When it happens

It fires when JIT is enabled and the compiler needed a function signature that the JIT type registry does not know — typically a mismatch after a build change or an unusual code path.

## How to fix

As a workaround, disable JIT (`SET jit = off`) so the query runs interpreted. If it recurs, capture the function name and the query and report it as a JIT bug.

## Example

*Illustrative* — a function missing from the JIT type registry.

```text
ERROR:  function my_func not in llvmjit_types.c
```

## Related

- [failed to JIT module](./failed-to-jit-module.md)
- [function with OID does not exist](./function-with-oid-does-not-exist.md)
