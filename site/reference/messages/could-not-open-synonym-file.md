---
message: "could not open synonym file \"%s\": %m"
slug: could-not-open-synonym-file
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/contrib/dict_xsyn/dict_xsyn.c:86"
  - "postgres/src/backend/tsearch/dict_synonym.c:131"
reproduced: false
---

# `could not open synonym file "%s": %m`

## What it means

A text-search synonym dictionary could not open its synonym file. The `%s` is the path and the `%m` is the operating-system error. The dictionary cannot load its rules.

## When it happens

The file named in the dictionary's `SYNONYMS` option was missing, misspelled, or unreadable, or it was not placed under the server's `$SHAREDIR/tsearch_data` directory. It fires when the dictionary is created or first used.

## How to fix

Place the synonym file (with the `.syn` extension) in `$SHAREDIR/tsearch_data` and reference it by base name in the `SYNONYMS` option. Confirm the server user can read it.

## Example

*Illustrative* — a missing synonym file.

```text
ERROR:  could not open synonym file "/usr/share/postgresql/tsearch_data/my.syn": No such file or directory
```

## Related

- [could not open temporary file](./could-not-open-temporary-file.md)
- [function should return type](./function-should-return-type.md)
