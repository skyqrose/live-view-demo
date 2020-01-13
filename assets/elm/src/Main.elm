module Main exposing (main)

import Browser
import Html


main : Program () () ()
main =
    Browser.application
        { init = \_ _ _ -> ( (), Cmd.none )
        , view =
            \_ ->
                { title = "Elm Demo"
                , body =
                    [ Html.text "Hello World!"
                    ]
                }
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = \_ -> ()
        , onUrlChange = \_ -> ()
        }
