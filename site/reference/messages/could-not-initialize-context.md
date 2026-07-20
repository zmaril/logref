---
message: "could not initialize %s context: %s"
slug: could-not-initialize-context
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/uuid-ossp/uuid-ossp.c:337"
  - "postgres/contrib/uuid-ossp/uuid-ossp.c:356"
  - "postgres/src/backend/utils/adt/cryptohashfuncs.c:119"
reproduced: false
---

# `could not initialize %s context: %s`

## What it means

The `uuid-ossp` extension got a failure while initializing a UUID-generation context in its backing library. The placeholders name the context and the library error. It surfaces from the OSSP/library backend that produces certain UUID versions.

## When it happens

Generating UUIDs through `uuid-ossp` when the underlying library returns an error at initialization — usually a library installation, environment, or build problem rather than SQL input.

## How to fix

Check the appended library error and confirm `uuid-ossp` and its dependency library are installed correctly for this server version. The built-in `gen_random_uuid()` avoids the external library for most needs. Report reproducible cases with the library error.

## Example

*Illustrative* — a library init failure in uuid-ossp.

```text
ERROR:  could not initialize uuid context: ...
```

## Related

- [could not finalize context](./could-not-finalize-context.md)
- [could not update context](./could-not-update-context.md)
