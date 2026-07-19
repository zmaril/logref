---
message: "expected prefixed symbol name, but got \"%s\""
slug: expected-prefixed-symbol-name-but-got
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/jit/llvm/llvmjit.c:1101"
reproduced: false
---

# `expected prefixed symbol name, but got "%s"`

## What it means

An internal guard in the LLVM JIT provider. While resolving a compiled symbol name, it expected a name with the internal prefix and found one without it. The placeholder is the name it saw. It is an invariant in the just-in-time compilation machinery.

## When it happens

It fires when JIT compilation is enabled and the generated-code symbol resolver encounters an unexpectedly named symbol. In normal operation the emitted names carry the expected prefix.

## How to fix

This is an internal invariant, not a user setting. As a stopgap you can disable JIT for the affected session with `SET jit = off` (or globally in `postgresql.conf`) to sidestep the code path. Capture the query and the server's LLVM version and report it, since it usually indicates a JIT or build issue.

## Example

*Illustrative* — disable JIT to work around it.

```sql
SET jit = off;
```

## Related

- [`extensible node name is too long`](./extensible-node-name-is-too-long.md)
- [ExtensibleNodeMethods was not registered](./extensiblenodemethods-was-not-registered.md)
