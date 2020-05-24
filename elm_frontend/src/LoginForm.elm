module LoginForm exposing (..)

import Element exposing (centerX, column, el, height, padding, px, text, width)
import Element.Border
import Element.Input


type LoginFormMsg
    = Username String
    | Password String

login_form_view model =
    column [ width <| px 100, height <| px 200, centerX, padding 20
     , Element.Border.solid, Element.Border.width 2
     ]
        [

          Element.Input.text []{onChange = Username, text = "Placeholder", placeholder = Nothing, label =  Element.Input.labelAbove [] <| text "Label above" }
        , text "World"
        ]
