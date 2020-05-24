module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Element exposing (alignLeft, centerX, el, fill, height, image, padding, paragraph, px, rgb, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border exposing (color)
import Element.Events exposing (onClick)
import Element.Input exposing (button)
import Task
import Time
import Url


type alias Model =
    {
     zone : Time.Zone
    , time : Time.Posix
    , key : Nav.Key
    , url : Url.Url
    , main_model: MainModel
    }

type alias MainModel =
    {
    a : String
    }

type Msg
    = NoOp
    | Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | HomeClicked
    | ProfileClicked
    | LogoutClicked
    | UrlChanged Url.Url




main : Program () Model Msg
main =
    Browser.application { init = init, view = view, update = update, subscriptions = subscriptions, onUrlRequest = onUrlRequest, onUrlChange = UrlChanged }


view : Model -> Document Msg
view model =
    { title = "Page title"
    , body =
        [ Element.layout [] <|
            Element.column
                [ spacing 15
                , padding 15
                , centerX
                ]
                [ title_bar model
                ]
        ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Tick newTime ->
            ( { model | time = newTime }, Cmd.none )

        AdjustTimeZone zone ->
            ( { model | zone = zone }, Cmd.none )

        HomeClicked ->
            ( model, Nav.pushUrl model.key <| Url.toString model.url ++ "extra chars" )

        ProfileClicked ->
            ( model, Cmd.none )

        LogoutClicked ->
            ( model, Cmd.none )

        UrlChanged url ->
            ( model, Cmd.none )

subscriptions model =
    Time.every 1000 Tick


onUrlRequest request =
    NoOp


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( {  zone = Time.utc, time = Time.millisToPosix 0, key = key, url = url, main_model = {a =  ""} }, Task.perform AdjustTimeZone Time.here )


title_bar model =
    row
        [ alignLeft
        , padding 20
        , spacing 20
        , Background.color <| rgb 10 10 10
        , Border.solid
        , Border.width <| 1
        , Border.rounded 10
        , Border.shadow { offset = ( 10, 10 ), size = 3, blur = 0, color = rgb255 0 0 10 }
        ]
        [ image [ width <| px 50, height <| px 50 ] { description = "image_desc", src = "https://avatars0.githubusercontent.com/u/285019?s=460&u=11f599c6bf0717819b628163dca450240bcdba62&v=4" }
        , paragraph [ onClick HomeClicked ] [ text "Home" ]
        , paragraph [ onClick ProfileClicked ] [ text "Profile" ]
        , button [] { onPress = Just LogoutClicked, label = text "Logout" }
        , text <| String.fromInt (Time.toSecond model.zone model.time)
        , text model.main_model.a
        ]
