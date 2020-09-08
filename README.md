# ULIDs in Elm

This package implements the [ULID specification](https://github.com/ulid/spec) for generating universally unique 128 bit identifiers.

Benefits of ULID, per the spec:

* 128-bit compatibility with UUID
* 1.21e+24 unique ULIDs per millisecond
* Lexicographically sortable!
* Canonically encoded as a 26 character string, as opposed to the 36 character UUID
* Uses Crockford's base32 for better efficiency and readability (5 bits per character)
* Case insensitive
* No special characters (URL safe)
* Monotonic sort order (correctly detects and handles the same millisecond)

```elm
import Ulid

type alias Model =
    { idGenerator : Ulid.Generator
    , ...
    }

type Msg
    = GotUlid String
```
