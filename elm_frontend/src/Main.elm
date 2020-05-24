module Main exposing (main)

import Browser exposing (Document)
import Element exposing (alignLeft, el, height, image, padding, paragraph, px, rgb, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border exposing (color)


type alias Model =
    { a : String
    }


type Msg
    = HomePressed
    | ProfilePressed
    | LogoutPressed
    | NoOp


main : Program () Model Msg
main =
    Browser.application { init = init, view = view, update = update, subscriptions = subscriptions, onUrlRequest = onUrlRequest, onUrlChange = onUrlChange }


view : Model -> Document Msg
view model =
    { title = "Page title", body = [ Element.layout [] <| title_bar ] }


update msg model =
    ( model, Cmd.none )


subscriptions model =
    Sub.none


onUrlRequest request =
    NoOp


onUrlChange url =
    NoOp


init flags url key =
    ( { a = "aval" }, Cmd.none )


title_bar =
    row
        [ alignLeft
        , padding 10
        , spacing 10
        , Background.color <| rgb 10 10 10
        , Border.solid
        , Border.width <| 1
        , Border.rounded 10
        , Border.shadow { offset = ( 10, 10 ), size = 3, blur = 0, color = rgb255 0 0 10 }
        ]
        [ image [ width <| px 50, height <| px 50 ] { description = "image_desc", src = "https://avatars0.githubusercontent.com/u/285019?s=460&u=11f599c6bf0717819b628163dca450240bcdba62&v=4" }
        , paragraph [] [ text "Home" ]
        , paragraph [] [ text "Profile" ]
        , paragraph [] [ text "Logout" ]
        ]
