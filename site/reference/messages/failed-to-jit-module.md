---
message: "failed to JIT module: %s"
slug: failed-to-jit-module
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/jit/llvm/llvmjit.c:700"
  - "postgres/src/backend/jit/llvm/llvmjit.c:795"
reproduced: false
---

# `failed to JIT module: %s`

## What it means

The JIT engine (LLVM) could not compile a module for a query. The `%s` is the LLVM error. Just-in-time compilation of the expression or tuple-deforming code failed.

## When it happens

It fires when JIT is enabled and LLVM rejected the generated module — often from an environment, LLVM-version, or resource issue rather than the SQL itself.

## How to fix

Read the LLVM error. As a workaround, disable JIT (`SET jit = off`, or raise the JIT cost thresholds) so the query runs interpreted. Check the LLVM installation and version compatibility if it persists.

## Example

*Illustrative* — LLVM failed to compile a module.

```text
ERROR:  failed to JIT module: Unable to materialize
```

## Related

- [function not in llvmjit_types.c](./function-not-in-llvmjit-types-c.md)
- [geqo failed to make a valid plan](./geqo-failed-to-make-a-valid-plan.md)
