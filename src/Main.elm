module Main exposing (main)

import Html
import Platform.Sub as Sub


main =
    Html.program
        { init = ( (), Cmd.none )
        , update = \_ _ -> ( (), Cmd.none )
        , subscriptions = \_ -> Sub.none
        , view = view
        }


view model =
    Html.text "Behold, Elm NYC!"
