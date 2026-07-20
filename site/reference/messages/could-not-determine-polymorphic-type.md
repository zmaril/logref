---
message: "could not determine polymorphic type"
slug: could-not-determine-polymorphic-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/fmgr/funcapi.c:650"
  - "postgres/src/backend/utils/fmgr/funcapi.c:676"
  - "postgres/src/backend/utils/fmgr/funcapi.c:705"
  - "postgres/src/backend/utils/fmgr/funcapi.c:732"
reproduced: false
---

# `could not determine polymorphic type`

## What it means

Internal error. Function-call support code (`funcapi`) tried to resolve a polymorphic pseudo-type (`anyelement`, `anyarray`, and friends) to a concrete type and could not from the information available. It is a guard reached when the actual type cannot be pinned down at run time.

## When it happens

It generally indicates a set-returning or polymorphic function whose definition does not give Postgres enough type information to resolve its output — often a function-definition problem, sometimes in an extension.

## How to fix

If you maintain the function, ensure it declares enough type information for polymorphic resolution (for example a matching polymorphic input, or `TABLE(...)`/`OUT` column types). Passing arguments with concrete types, or casting a null input to the intended type, often resolves it. If it comes from an extension, report it.

## Example

*Illustrative* — emitted when a polymorphic type cannot be resolved.

```text
ERROR:  could not determine polymorphic type
```

## Related

- [could not determine actual enum type](./could-not-determine-actual-enum-type.md)
- [argument declared is not consistent with argument declared](./argument-declared-is-not-consistent-with-argument-declared.md)
