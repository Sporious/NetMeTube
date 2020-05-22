module LoginBox exposing (..)



type alias InputFields   =
    {
    username : String,
    password : String
    }

--login box model

type alias Model =
    {
    inputs : InputFields
    }