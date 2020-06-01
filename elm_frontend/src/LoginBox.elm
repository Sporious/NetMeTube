module LoginBox exposing (..)

import Element exposing (Attribute, Element, centerX, column, padding, px, rgb255, spacing, text)
import Element.Border exposing (shadow, solid, width)
import Element.Font as Font
import Element.Input
import String exposing (map)
import Validate exposing (Validator, fromValid, ifBlank, ifInvalidEmail, isValidEmail, validate)


type alias Model =
    { email : String
    , email_entry_colour : Attribute Msg
    , password : String
    }


type Msg
    = NoOp
    | EmailEdited String
    | PasswordEdited String
    | LoginButtonPressed


view : Model -> Element Msg
view m =
    column [ Element.centerX, padding 20, spacing 15, solid, width 2 ]
        [ Element.Input.text [ m.email_entry_colour ]
            { onChange =
                EmailEdited
            , text = m.email
            , placeholder = Nothing
            , label = Element.Input.labelAbove [] (text "Email:")
            }
        , Element.Input.text [ centerX ] { onChange = PasswordEdited, text = m.password, placeholder = Nothing, label = Element.Input.labelAbove [] (text "Password:") }
        , Element.Input.button [ Element.Border.solid, Element.Border.rounded 5, padding 10, width 1, centerX ] { onPress = Just LoginButtonPressed, label = text "Login!" }
        ]


init : Model
init =
    { email = "", password = "", email_entry_colour = Font.color (rgb255 0 0 0) }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        EmailEdited email ->
            validate_model { model | email = email }

        PasswordEdited password ->
            ( { model | password = password }, Cmd.none )

        LoginButtonPressed ->
            ( model, Cmd.none )


validate_model model =
    case Debug.log "Validation" <| validate model_validator model of
        Ok v ->
            ( fromValid v, Cmd.none )

        _  ->
            ( model, Cmd.none )


model_validator : Validator String Model
model_validator =
    Validate.all [ ifBlank .email "Enter email", ifInvalidEmail .email (\_ -> "Email is invalid") ]
