port module Main exposing (main, reactor)

import Html exposing (Html)
import Html.Events as Events
import Http
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Encode as Encode


port fromElm : Value -> Cmd msg


port toElm : (Value -> msg) -> Sub msg


type Msg
    = Decrement
    | Incoming Value
    | Increment
    | ReceivedSomeData (Result Http.Error SomeData)


type alias SomeData =
    { some : String
    }

type alias Model =
    Int


defaultFlags : Value
defaultFlags =
    Encode.object
        [ ( "initialCounter", Encode.int 0 )
        ]


type alias Flags =
    { initialCounter : Int
    }


flagsDecoder : Decoder Flags
flagsDecoder =
    Decode.map Flags
        (Decode.field "initialCounter" Decode.int)


reactor : Program Never Model Msg
reactor =
    Html.program
        { init = init defaultFlags
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


main : Program Value Model Msg
main =
    Html.programWithFlags
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ toElm Incoming
        ]


decodeSomeData : Decoder SomeData
decodeSomeData =
    Decode.map SomeData
        (Decode.field "some" Decode.string)


init : Value -> ( Model, Cmd Msg )
init flags =
    case Decode.decodeValue flagsDecoder flags of
        Ok { initialCounter } ->
            let
                request =
                    Http.get "/assets/some-data.json" decodeSomeData
            in
            ( initialCounter, Http.send ReceivedSomeData request )

        Err reason ->
            Debug.log ("Flags could not be decoded: " ++ reason)
                ( 0, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg counter =
    case msg of
        Decrement ->
            ( counter - 1, Cmd.none )

        Incoming data ->
            case Decode.decodeValue Decode.string data of
                Ok incomingMsg ->
                    Debug.log ("[Elm] incoming " ++ toString incomingMsg)
                        ( counter
                        , fromElm (Encode.string "I have seen the future!")
                        )

                Err reason ->
                    Debug.log
                        ("[Elm] error decoding incoming: " ++ reason)
                        ( counter, Cmd.none )

        Increment ->
            ( counter + 1, Cmd.none )


        ReceivedSomeData result ->
            case result of
                Ok { some } ->
                    Debug.log ("[Elm] received: " ++ toString result)
                        ( counter, Cmd.none )

                Err httpError ->
                    Debug.log
                        ("[Elm] error decoding some data: " ++ toString httpError)
                        ( counter, Cmd.none )


view : Model -> Html Msg
view counter =
    Html.div []
        [ Html.button [ Events.onClick Decrement ]
            [ Html.text "-"
            ]
        , Html.text (toString counter)
        , Html.button [ Events.onClick Increment ]
            [ Html.text "+"
            ]
        ]
