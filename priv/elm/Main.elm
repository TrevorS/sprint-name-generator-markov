import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

main = Html.beginnerProgram { model = model, update = update, view = view }

-- MODEL
type alias Model = String

model : Model
model =
  ""

-- UPDATE
type Msg = GetSprintName | ClearSprintName

update : Msg -> Model -> Model
update msg model =
  case msg of
    GetSprintName ->
      model ++ "did it "

    ClearSprintName ->
      ""

-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ button [ onClick GetSprintName ] [ text "Get Sprint Name" ]
    , button [ onClick ClearSprintName ] [ text "Clear" ]
    , div [] [ text model ]
    ]
