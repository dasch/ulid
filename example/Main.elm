module Main exposing (main)

import Browser
import Html exposing (Html, button, code, div, text)
import Html.Events exposing (onClick)
import Task
import Ulid


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }


type Msg
    = GenerateUlid
    | LoadUlid (Result Ulid.Error ( String, Ulid.Generator ))


type alias Model =
    { ulid : Maybe String
    , ulidGenerator : Ulid.Generator
    , error : Maybe Ulid.Error
    }


init : ( Model, Cmd Msg )
init =
    ( { ulid = Nothing
      , error = Nothing
      , ulidGenerator = Ulid.init 42
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GenerateUlid ->
            ( model, generateUlid model.ulidGenerator )

        LoadUlid (Ok ( ulid, ulidGenerator )) ->
            ( { model | ulid = Just ulid, ulidGenerator = ulidGenerator }
            , Cmd.none
            )

        LoadUlid (Err err) ->
            Debug.log (Debug.toString err) ( model, Cmd.none )


generateUlid : Ulid.Generator -> Cmd Msg
generateUlid ulidGenerator =
    Ulid.generate ulidGenerator
        |> Task.attempt LoadUlid


view : Model -> Html Msg
view model =
    div []
        [ div [] [ code [] [ text (Maybe.withDefault "--" model.ulid) ] ]
        , button [ onClick GenerateUlid ] [ text "Generate ULID" ]
        ]
