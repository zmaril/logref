---
message: "could not set up XML error handler"
slug: could-not-set-up-xml-error-handler
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/xml.c:1307"
reproduced: false
---

# `could not set up XML error handler`

## What it means

An XML function could not install the error handler it uses to capture messages from the underlying XML library. The server reports this as an unsupported feature. Without the handler, XML errors could not be reported cleanly.

## When it happens

It fires when XML processing initializes and the error-handler setup fails, which most often happens with a libxml build that is too old or otherwise incompatible with what Postgres expects.

## How to fix

This points at the libxml library the server links against. Make sure Postgres was built and is running against a supported libxml version. If XML support was expected to work, check the installation and the library version; upgrading libxml to a supported release resolves it.

## Example

*Illustrative* — the XML error handler could not be set up.

```text
ERROR:  could not set up XML error handler
HINT:  This function requires libxml2 version 2.7.4 or later.
```

## Related

- [could not register XML namespace with name and URI](./could-not-register-xml-namespace-with-name-and-uri.md)
- [could not set libxslt security preferences](./could-not-set-libxslt-security-preferences.md)
