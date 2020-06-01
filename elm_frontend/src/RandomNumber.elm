module RandomNumber exposing (..)

import Browser
import Html exposing (Html, button, div, p, text)
import Html.Events exposing (onClick)
import Random


type alias Model =
    { r : Int, g : Int, b : Int }


init : () -> ( Model, Cmd msg )
init _ =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    { r = 0, g = 0, b = 0 }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick GenerateRandomNumber ] [ text "Generate random number" ]
        , div [] [ text (String.fromInt model.r) ]
        , div [] [ text (String.fromInt model.g) ]
        , div [] [ text (String.fromInt model.b) ]
        ]


type alias RGB =
    { r : Int, g : Int, b : Int }


colour_generator : Random.Generator RGB
colour_generator =
    Random.map3 (\a b c -> RGB a b c) (Random.int 0 100) (Random.int 0 100) (Random.int 0 100)


type Msg
    = GenerateRandomNumber
    | NewRandomNumber RGB


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GenerateRandomNumber ->
            ( model, Random.generate NewRandomNumber colour_generator )

        NewRandomNumber v ->
            ( { model | r = v.r, g = v.g, b = v.b }, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
