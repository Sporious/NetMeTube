module Main exposing (..)

import Browser
import Html exposing (input, text)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (onInput)



-- Initialise Browser sandbox with program arguments


main =
    Browser.sandbox { init = init, update = update, view = view }



--Init function sets up initial state


init =
    0



--Update based on msg


update msg model =
    model



--View from model


view model =
    text "Hello world"



