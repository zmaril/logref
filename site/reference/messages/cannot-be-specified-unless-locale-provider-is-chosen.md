---
message: "%s cannot be specified unless locale provider \"%s\" is chosen"
slug: cannot-be-specified-unless-locale-provider-is-chosen
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:3456"
  - "postgres/src/bin/initdb/initdb.c:3460"
  - "postgres/src/bin/initdb/initdb.c:3464"
reproduced: false
---

# `%s cannot be specified unless locale provider "%s" is chosen`

## What it means

A locale-related option was given to `initdb` (or a database create) that only applies when a specific locale provider is selected, but that provider was not chosen. The placeholders name the option and the required provider. Options like ICU rules or ICU locale settings are meaningful only under the ICU provider.

## When it happens

Passing an ICU-specific option (for example `--icu-locale` or `--icu-rules`) without also selecting `--locale-provider=icu`, or a provider-specific option that does not match the chosen provider.

## How to fix

Either select the matching locale provider (`--locale-provider=icu`) so the option applies, or drop the provider-specific option if you meant to use the default (libc) provider. Make the provider and its options consistent.

## Example

*Illustrative* — an ICU option without the ICU provider.

```sh
initdb --icu-locale=en -D /data   # ... unless locale provider "icu" is chosen
```

## Related

- [locale name contains non-ASCII characters](./locale-name-contains-non-ascii-characters.md)
- [parameter must be specified](./parameter-must-be-specified.md)
