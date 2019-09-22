-- Make a GET request to load a book called "Public Opinion"
--
-- Read how it works:
--   https://guide.elm-lang.org/effects/http.html
--


module Main exposing (Model(..), Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import List
import Models as M exposing (..)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Model
    = DisplayBook Book


init : () -> ( Model, Cmd Msg )
init _ =
    ( DisplayBook initialBook
    , Cmd.none
    )


type Msg
    = SelectedBook Book


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectedBook book ->
            ( DisplayBook book, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


isJust : Maybe t -> Bool
isJust val =
    case val of
        Nothing ->
            False

        Just _ ->
            True


hasRead : Maybe Mastery -> Bool
hasRead mastery =
    case mastery of
        Nothing ->
            False

        Just { read } ->
            read


view : Model -> Html Msg
view model =
    case model of
        DisplayBook book ->
            div [ class "container" ]
                [ h1 []
                    [ text book.title ]
                , div []
                    [ displayPart
                        book.parts
                    ]
                ]


displayPart : List Part -> Html Msg
displayPart parts =
    let
        createPartElems =
            \part ->
                div [ class "card mb-3" ]
                    [ div [ class "card-header" ] [ text (Maybe.withDefault "" part.name) ]
                    , displayChapters part.chapters
                    ]

        contents =
            List.map createPartElems parts
    in
    div [] contents


displayChapters : List Chapter -> Html Msg
displayChapters chapters =
    let
        createListElems =
            \chapter ->
                li [ class "list-group-item" ] [ text chapter.name ]

        contents =
            List.map createListElems chapters
    in
    ul [ class "list-group list-group-flush" ] contents
