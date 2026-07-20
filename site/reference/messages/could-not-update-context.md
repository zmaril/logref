---
message: "could not update %s context: %s"
slug: could-not-update-context
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/uuid-ossp/uuid-ossp.c:341"
  - "postgres/contrib/uuid-ossp/uuid-ossp.c:360"
  - "postgres/src/backend/utils/adt/cryptohashfuncs.c:122"
reproduced: false
---

# `could not update %s context: %s`

## What it means

The `uuid-ossp` extension got a failure while updating (feeding data into) a UUID-generation context in its backing library. The placeholders name the context and the library error. It surfaces from the OSSP/library backend used for certain UUID versions.

## When it happens

Generating UUIDs through `uuid-ossp` when the underlying library errors mid-computation — typically a library installation or environment problem rather than SQL input.

## How to fix

Check the appended library error and confirm `uuid-ossp` and its dependency library are installed correctly for this server version. The built-in `gen_random_uuid()` avoids the external dependency. Report reproducible cases with the library error.

## Example

*Illustrative* — a library update failure in uuid-ossp.

```text
ERROR:  could not update uuid context: ...
```

## Related

- [could not initialize context](./could-not-initialize-context.md)
- [could not finalize context](./could-not-finalize-context.md)
