module Ulid exposing (decode, encode)

import Crockford


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
