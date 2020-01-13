module Main exposing (main)

import Time
import Browser
import Browser.Navigation as Navigation
import Html exposing (Html)
import Html.Attributes as Attributes
import Http
import Json.Decode as Decode
import Url


type alias Model =
    { routeId : RouteId
    , route : Maybe Route
    }


type Msg
    = Noop
    | Tick
    | GotRoute (Result Http.Error Route)


type alias RouteId =
    String


type alias Route =
    { id : RouteId
    , name : String
    , stops : List Stop
    , vehicles : List Vehicle
    }


type alias Stop =
    { id : String
    , name : String
    , predictions : List Prediction
    }


type alias Prediction =
    { id : String
    , minutes : Int
    }


type alias Vehicle =
    { id : String
    , latitude : Float
    , longitude : Float
    }


decodeRoute : Decode.Decoder Route
decodeRoute =
    Decode.map4
        Route
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "stops" (Decode.list decodeStop))
        (Decode.field "vehicles" (Decode.list decodeVehicle))


decodeStop : Decode.Decoder Stop
decodeStop =
    Decode.map3
        Stop
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "predictions" (Decode.list decodePrediction))


decodePrediction : Decode.Decoder Prediction
decodePrediction =
    Decode.map2
        Prediction
        (Decode.field "id" Decode.string)
        (Decode.field "minutes" Decode.int)


decodeVehicle : Decode.Decoder Vehicle
decodeVehicle =
    Decode.map3
        Vehicle
        (Decode.field "id" Decode.string)
        (Decode.field "latitude" Decode.float)
        (Decode.field "longitude" Decode.float)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = \_ -> Noop
        , onUrlChange = \_ -> Noop
        }


init : flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url _ =
    let
        routeId =
            case String.split "/" url.path of
                [ "", "demo", "elm", id ] ->
                    id

                _ ->
                    "???"
    in
    ( { routeId = routeId
      , route = Nothing
      }
    , fetch routeId
    )


fetch : RouteId -> Cmd Msg
fetch routeId =
    Http.get
        { url = "/demo/react_api/" ++ routeId
        , expect = Http.expectJson GotRoute decodeRoute
        }

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 5000 (\_ -> Tick)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model
            , Cmd.none
            )

        Tick ->
          ( model
          , fetch model.routeId
          )

        GotRoute httpResult ->
            case httpResult of
                Ok route ->
                    ( { model
                        | route = Just route
                      }
                    , Cmd.none
                    )

                Err e ->
                    ( model
                    , Cmd.none
                    )


view : Model -> Browser.Document msg
view model =
    { title = "Elm Demo"
    , body =
        case model.route of
            Nothing ->
                [ Html.text "Loading..." ]

            Just route ->
                viewRoute route
    }


viewRoute : Route -> List (Html msg)
viewRoute route =
    [ Html.h2 [] [ Html.text route.name ]
    , viewStops route.stops
    ]


viewStops : List Stop -> Html msg
viewStops stops =
    Html.table
        [ Attributes.attribute "border" "1"
        , Attributes.attribute "cellPadding" "8"
        , Attributes.attribute "cellSpacing" "0"
        ]
        [ Html.tbody
            []
            (List.map viewStop stops)
        ]


viewStop : Stop -> Html msg
viewStop stop =
    Html.tr
        []
        [ Html.td
            []
            [ Html.text stop.name ]
        , Html.td
            []
            (List.map viewPrediction stop.predictions)
        ]


viewPrediction : Prediction -> Html msg
viewPrediction prediction =
    Html.div
        []
        [ Html.text (String.fromInt prediction.minutes ++ " min.") ]
