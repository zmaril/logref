---
message: "could not finalize %s context: %s"
slug: could-not-finalize-context
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/uuid-ossp/uuid-ossp.c:346"
  - "postgres/contrib/uuid-ossp/uuid-ossp.c:363"
  - "postgres/src/backend/utils/adt/cryptohashfuncs.c:126"
reproduced: false
---

# `could not finalize %s context: %s`

## What it means

The `uuid-ossp` extension got a failure while finalizing a cryptographic/UUID-generation context in its underlying library. The placeholders name the context and the library error. It surfaces from the OSSP/library backend that generates certain UUID versions.

## When it happens

Generating UUIDs through `uuid-ossp` when the backing library (OSSP uuid, or the configured alternative) returns an error at the finalize step — often a library build, initialization, or environment problem rather than SQL input.

## How to fix

Check the appended library error. Verify the `uuid-ossp` extension and its dependency library are correctly installed for this server version; a mismatched or broken library is the usual cause. For most modern needs the built-in `gen_random_uuid()` avoids the external dependency entirely. Report reproducible cases with the library error.

## Example

*Illustrative* — a library finalize failure in uuid-ossp.

```text
ERROR:  could not finalize uuid context: ...
```

## Related

- [could not initialize context](./could-not-initialize-context.md)
- [could not update context](./could-not-update-context.md)
