module LeftBar exposing (..)

import Browser
import Html exposing (Html, text)


type alias Model =
    {}


type Msg
    = NoOp


view : Model -> Html Msg
view model =
    text "Hello world"


update : Msg -> Model -> Model
update msg model =
    model


init : Model
init =
    {}


main =
    Browser.sandbox { init = init, update = update, view = view }
