import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode

main : Program Never Model Msg
main =
  Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

-- INIT
init : (Model, Cmd Msg)
init =
  ( Model []
  , getSprintName
  )

-- MODEL
type alias Model =
  { sprintName : List String
  }

model : Model
model =
  { sprintName = [] }

-- UPDATE
type Msg
  = GetSprintName
  | ClearSprintName
  | NewSprintName (Result Http.Error Model)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetSprintName ->
      (model, getSprintName)

    ClearSprintName ->
      (Model [], Cmd.none)

    NewSprintName (Ok newSprintName) ->
      (newSprintName, Cmd.none)

    NewSprintName (Err _) ->
      (Model ["Error"], Cmd.none)

-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ button [ onClick GetSprintName ] [ text "Get Sprint Name" ]
    , button [ onClick ClearSprintName ] [ text "Clear" ]
    , div [] [ text (String.join " " model.sprintName) ]
    ]

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

-- HTTP
getSprintName : Cmd Msg
getSprintName =
  let url =
    "http://localhost:4000/corpora/3/sprint-name"
  in
    Http.send NewSprintName (Http.get url decodeSprintName)

decodeSprintName : Decode.Decoder Model
decodeSprintName =
  Decode.map
    Model
    (Decode.at ["sprint_name"] (Decode.list Decode.string))
