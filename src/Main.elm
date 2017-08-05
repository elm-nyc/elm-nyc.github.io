module Main exposing (main)

import Html
import Platform.Sub as Sub
import Element exposing (text)
import Style


main =
    Html.program
        { init = ( (), Cmd.none )
        , update = \_ _ -> ( (), Cmd.none )
        , subscriptions = \_ -> Sub.none
        , view = view
        }


view model =
    Element.viewport styleSheet <|
        text "Behold, Elm NYC!"


styleSheet =
    Style.styleSheet []
