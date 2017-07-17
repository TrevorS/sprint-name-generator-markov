import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

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
type Msg = GetSprintName | ClearSprintName

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetSprintName ->
      let
        newState =
          { model | sprintName = ["did", "it"] }

      in
        (newState, Cmd.none)

    ClearSprintName ->
      let
        newState =
          { model | sprintName = [] }

      in
        (newState, Cmd.none)

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
getSprintName = Cmd.none
