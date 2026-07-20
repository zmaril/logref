---
message: "\"%s\" setting \"%s\" not supported by this build"
slug: setting-not-supported-by-this-build
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:421"
  - "postgres/src/backend/libpq/be-secure-openssl.c:444"
reproduced: false
---

# `"%s" setting "%s" not supported by this build`

## What it means

A configuration setting was given a value that this particular build of Postgres cannot honor, because the feature it depends on was not compiled in.

## When it happens

It arises when a parameter references an optional capability the binary lacks — for example an SSL, GSSAPI, or ICU-related setting on a build compiled without that support.

## Is this a problem?

The severity depends on the caller. Either remove or change the setting to a value the build supports, or install a build compiled with the required option. Check the feature flags of your Postgres package if you need the capability the setting asks for.

## Example

*Illustrative* — a setting that needs a capability the build lacks.

```text
LOG:  "ssl" setting "on" not supported by this build
```

## Related

- [unrecognized configuration parameter](./unrecognized-configuration-parameter.md)
- [unrecognized authentication option name](./unrecognized-authentication-option-name.md)
