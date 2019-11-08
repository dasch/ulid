module UlidTests exposing (suite)

import Expect
import Fuzz
import Random
import Test exposing (..)
import Ulid


suite : Test
suite =
    describe "Ulid"
        [ describe "encode"
            [ fuzz2 nonNegativeInt nonNegativeInt "encodes timestamp and randomness as base32" <|
                \timestamp random ->
                    Ulid.encode ( timestamp, random )
                        |> Result.andThen Ulid.decode
                        |> Expect.equal (Ok ( timestamp, random ))
            ]
        ]


nonNegativeInt =
    Fuzz.intRange 0 Random.maxInt
