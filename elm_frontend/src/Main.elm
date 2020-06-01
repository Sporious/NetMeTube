module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Element exposing (Color, alignLeft, centerX, el, fill, height, image, padding, paragraph, px, rgb, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border exposing (color)
import Element.Events exposing (onClick)
import Element.Input exposing (button)
import Html
import LoginBox
import Random
import Result exposing (andThen)
import Task
import Time
import Url


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    , key : Nav.Key
    , url : Url.Url
    , a : String
    , colour : Color
    , login_model : LoginBox.Model
    }


type Msg
    = NoOp
    | Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | HomeClicked
    | ProfileClicked
    | LogoutClicked
    | UrlChanged Url.Url
    | TriggerNewRandomColours Time.Posix
    | ApplyColours ( Int, Int, Int )
    | LoginMsg LoginBox.Msg


main : Program () Model Msg
main =
    Debug.log "main " "Hello world program"
        |> (\_ ->
                Browser.application { init = init, view = view, update = update, subscriptions = subscriptions, onUrlRequest = onUrlRequest, onUrlChange = UrlChanged }
           )


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
                , Element.map LoginMsg (LoginBox.view model.login_model)
                ]
        ]
    }


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( NoOp, _ ) ->
            ( model, Cmd.none )

        ( Tick newTime, _ ) ->
            ( { model | time = newTime }, Cmd.none )

        ( AdjustTimeZone zone, _ ) ->
            ( { model | zone = zone }, Cmd.none )

        ( HomeClicked, _ ) ->
            ( model, Nav.pushUrl model.key <| Url.toString model.url ++ "extra chars" )

        ( ProfileClicked, _ ) ->
            ( model, Cmd.none )

        ( LogoutClicked, _ ) ->
            ( model, Cmd.none )

        ( UrlChanged url, _ ) ->
            ( model, Cmd.none )

        ( TriggerNewRandomColours time, _ ) ->
            ( model, Random.generate ApplyColours colour_generator )

        ( ApplyColours ( r, g, b ), _ ) ->
            ( { model | colour = rgb255 r g b }, Cmd.none )

        ( LoginMsg subMsg, _ ) ->
            let
                ( login_model, subCmd ) =
                    LoginBox.update subMsg model.login_model
            in
            ( { model | login_model = login_model }, Cmd.map LoginMsg subCmd )


subscriptions model =
    Sub.batch [ Time.every 1000 Tick, Time.every 500 TriggerNewRandomColours ]


colour_generator : Random.Generator ( Int, Int, Int )
colour_generator =
    Random.map3 (\a b c -> ( a, b, c )) (Random.int 0 255) (Random.int 0 255) (Random.int 0 255)


onUrlRequest request =
    NoOp


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { zone = Time.utc, time = Time.millisToPosix 0, key = key, url = url, a = "", colour = rgb255 10 10 10, login_model = LoginBox.init }, Task.perform AdjustTimeZone Time.here )


title_bar model =
    row
        [ alignLeft
        , padding 20
        , spacing 20
        , Background.color <| rgb 10 10 10
        , Border.solid
        , Border.width 1
        , Border.rounded 10

        -- , Border.shadow { offset = ( 10, 10 ), size = 3, blur = 0, color = rgb255 0 0 10 }
        , Border.glow model.colour 5
        ]
        [ image [ width <| px 50, height <| px 50 ] { description = "image_desc", src = "https://avatars0.githubusercontent.com/u/285019?s=460&u=11f599c6bf0717819b628163dca450240bcdba62&v=4" }
        , paragraph [ onClick HomeClicked ] [ text "Home" ]
        , paragraph [ onClick ProfileClicked ] [ text "Profile" ]
        , button [] { onPress = Just LogoutClicked, label = text "Logout" }
        , text <| String.fromInt <| Time.toSecond model.zone model.time
        , text model.a
        ]
