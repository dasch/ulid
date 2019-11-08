module Ulid exposing (Error(..), Generator, decode, encode, generate, init)

import Crockford
import Random
import Task exposing (Task)
import Time


type Generator
    = Generator Random.Seed


type Error
    = EncodingError Crockford.Error
    | TimestampError


init : Int -> Generator
init seed =
    Generator (Random.initialSeed seed)


generate : Generator -> Task Error ( String, Generator )
generate (Generator seed) =
    let
        ( random, newSeed ) =
            Random.step randomInt seed

        encodeAndMap : Int -> Result Error ( String, Generator )
        encodeAndMap timestamp =
            encode ( timestamp, random )
                |> Result.map (\ulid -> ( ulid, Generator newSeed ))
                |> Result.mapError EncodingError
    in
    Task.map encodeAndMap timestampTask
        |> Task.andThen resultToTask



-- Encoding & decoding


timeLength =
    10


randomLength =
    16


encode : ( Int, Int ) -> Result Crockford.Error String
encode ( timestamp, random ) =
    let
        encodedTimestamp : Result Crockford.Error String
        encodedTimestamp =
            Crockford.encode timestamp
                |> Result.map (String.padLeft timeLength '0')

        encodedRandom : Result Crockford.Error String
        encodedRandom =
            Crockford.encode random
                |> Result.map (String.padLeft randomLength '0')
    in
    Result.map2 (++) encodedTimestamp encodedRandom


decode : String -> Result Crockford.Error ( Int, Int )
decode str =
    let
        timestamp =
            String.left timeLength str
                |> Crockford.decode

        random =
            String.dropLeft randomLength str
                |> Crockford.decode
    in
    Result.map2 Tuple.pair timestamp random



-- Utility functions


randomInt : Random.Generator Int
randomInt =
    Random.int 0 Random.maxInt


timestampTask : Task Error Int
timestampTask =
    Task.map Time.posixToMillis Time.now
        |> Task.mapError (always TimestampError)


resultToTask : Result x a -> Task x a
resultToTask result =
    case result of
        Ok value ->
            Task.succeed value

        Err err ->
            Task.fail err
