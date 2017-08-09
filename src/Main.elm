module Main exposing (main)

import Html
import Http
import Json.Decode as Json
import Color exposing (..)
import Platform.Sub as Sub
import Element exposing (..)
import Element.Attributes exposing (..)
import Style exposing (style)
import Style.Font as Font
import Style.Border as Border
import Style.Color as Color


main =
    Html.program
        { init = ( { nextMeetup = Nothing }, fetchMeetup )
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { nextMeetup : Maybe Meetup }


type alias Meetup =
    { name : String
    , link : String
    , time : Int
    }


fetchMeetup : Cmd Message
fetchMeetup =
    Http.get "http://api.meetup.com/Elm-NYC/events" meetupDecoder
        |> Http.send UpdateMeetup


meetupDecoder : Json.Decoder Meetup
meetupDecoder =
    Json.map3 Meetup
        (Json.field "name" Json.string)
        (Json.field "link" Json.string)
        (Json.field "time" Json.int)
        |> Json.index 0


type Message
    = UpdateMeetup (Result Http.Error Meetup)


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        UpdateMeetup result ->
            case result of
                Ok meetup ->
                    ( { model | nextMeetup = Just meetup }, Cmd.none )

                Err _ ->
                    ( { model | nextMeetup = Nothing }, Cmd.none )



-- view


type Styles
    = Title
    | Description
    | DescriptionLink
    | Footer
    | FooterText
    | FooterLink
    | None


view model =
    Element.viewport styleSheet <|
        column None [ height (percent 100), paddingXY 120 0 ] <|
            [ column None [ center, verticalCenter, spacing 20, height (fill 1) ] <|
                [ image "./images/logo.png" None [ width (px 200), height (px 200) ] empty
                , el Title [] (text "elm-nyc")
                , paragraph Description [] <|
                    [ text "welcome! join us on "
                    , text "slack" |> el DescriptionLink [ target "_blank" ] |> link "http://elmnyc.herokuapp.com/"
                    , text " or at our "
                    , text "meetup group" |> el DescriptionLink [ target "_blank" ] |> link "https://www.meetup.com/Elm-NYC/"
                    , text "."
                    ]
                , meetupView model
                ]
            , row Footer [ verticalCenter, center, spacing 100, height (px 75) ] <|
                [ paragraph FooterText [] <|
                    [ text "contact: ( "
                    , text "kara" |> el FooterLink [] |> link "mailto:krbernet@gmail.com"
                    , text ", "
                    , text "noah" |> el FooterLink [] |> link "mailto:noahzacharygordon@gmail.com"
                    , text " )"
                    ]
                , paragraph FooterText [] <|
                    [ text "code of conduct" |> el FooterLink [ target "_blank" ] |> link "https://docs.google.com/document/d/1zB9eTN-FMh3gYFSxXyV0hlFWg2uhr6JsfnOboVUMkUw/edit" ]
                ]
            ]


meetupView : Model -> Element Styles variation Message
meetupView model =
    case model.nextMeetup of
        Just meetup ->
            paragraph Description [] <|
                [ text "Sign up for our next meetup: "
                , text meetup.name |> el DescriptionLink [ target "_blank" ] |> link meetup.link
                ]

        Nothing ->
            paragraph Description [] <|
                [ text "No upcoming meetups have been scheduled yet. Stay tuned!" ]


fontStyles =
    [ Font.typeface [ "Montserrat", "sans-serif" ] ]


styleSheet =
    Style.styleSheet
        [ style Title <|
            [ Font.size 28 ]
                ++ fontStyles
        , style Description <|
            [ Font.size 20 ]
                ++ fontStyles
        , style DescriptionLink <|
            [ Color.text black
            , Font.bold
            , Style.hover
                [ Color.text (rgb 127 209 59) ]
            ]
                ++ fontStyles
        , style Footer
            [ Border.top 2, Border.solid, Color.border (greyscale 0.3) ]
        , style FooterText <|
            [ Color.text (greyscale 0.3) ]
                ++ fontStyles
        , style FooterLink <|
            [ Color.text (greyscale 0.3)
            , Font.bold
            , Style.hover
                [ Color.text (rgb 127 209 59) ]
            ]
                ++ fontStyles
        ]
