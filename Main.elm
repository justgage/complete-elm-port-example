port module Main exposing (main)

import Html exposing (Html, text, div, button, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (type_, value)
import Json.Encode exposing (Value)
import Json.Decode as Decode


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- TYPES


type alias Model =
    { message : String
    }


type Msg
    = UpdateStr String
    | SendToJs String



-- MODEL


init : ( Model, Cmd Msg )
init =
    ( { message = "Elm program is ready. Get started!" }, Cmd.none )



----- UPDATE


port toJs : String -> Cmd msg


port toElm : (Value -> msg) -> Sub msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateStr str ->
            ( { model | message = str }, Cmd.none )

        SendToJs str ->
            ( model, toJs str )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", onInput UpdateStr, value model.message ] []
        , div [] [ text model.message ]
        , button
            [ onClick (SendToJs model.message) ]
            [ text "Send To JS" ]
        ]



-- SUBSCRIPTIONS


decodeValue : Value -> Msg
decodeValue x =
    let
        result =
            Decode.decodeValue Decode.string x
    in
        case result of
            Ok string ->
                UpdateStr string

            Err _ ->
                UpdateStr "Silly JavaScript, you can't kill me!"


subscriptions : Model -> Sub Msg
subscriptions model =
    toElm (decodeValue)
