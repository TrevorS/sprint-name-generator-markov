import Html exposing (Html, button, div, input, text, ul, li)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Encode as Encode

main : Program Never Model Msg
main =
  Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = \_ -> Sub.none
  }

-- INIT
init : (Model, Cmd Msg)
init =
  ( Model [] "" ""
  , getSprintName
  )

-- MODEL
type alias Model =
  { sprintName : List String
  , newCorpusName : String
  , newCorpusText : String
  }

model : Model
model =
  { sprintName = []
  , newCorpusName = ""
  , newCorpusText = ""
  }

-- UPDATE
type Msg
  = GetSprintName
  | ClearSprintName
  | NewSprintName (Result Http.Error GetSprintNameResults)
  | ChangeNewCorpusTextInput String
  | ChangeNewCorpusNameInput String
  | SubmitCorpus
  | NewCorpus (Result Http.Error SubmitResponseResults)
  | ClearCorpus

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetSprintName ->
      (model, getSprintName)

    ClearSprintName ->
      let newModel =
        { model | sprintName = [] }

      in
        (newModel, Cmd.none)

    NewSprintName (Ok results) ->
      let newModel =
        { model | sprintName = results.sprint_name }

      in
        (newModel, Cmd.none)

    NewSprintName (Err _) ->
      (Model ["Error"] "" "", Cmd.none)

    ChangeNewCorpusTextInput inputText ->
      let newModel =
        { model | newCorpusText = inputText }

      in
        (newModel, Cmd.none)

    ChangeNewCorpusNameInput inputText ->
      let newModel =
        { model | newCorpusName = inputText }

      in
        (newModel, Cmd.none)

    SubmitCorpus ->
      (model, submitCorpus model)

    ClearCorpus ->
      let newModel =
        { model | newCorpusName = "", newCorpusText = "" }

      in
        (newModel, Cmd.none)

    NewCorpus (Ok results) ->
      Debug.crash("results: " ++ (toString results))

      (model, Cmd.none)

    NewCorpus (Err error) ->
      Debug.crash("error: " ++ (toString error))

      (model, Cmd.none)

-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ viewSprintName model
    , viewSprintNameButtons
    , viewNewCorpusNameInput
    , viewNewCorpusTextInput
    , viewNewCorpusSubmitButtons
    ]

viewSprintName : Model -> Html Msg
viewSprintName model =
  ul []
    (List.map (\word -> li [] [ text word ])
      model.sprintName)

viewSprintNameButtons : Html Msg
viewSprintNameButtons =
  div []
    [ button [ onClick GetSprintName ] [ text "Get Sprint Name" ]
    , button [ onClick ClearSprintName ] [ text "Clear" ]
    ]

viewNewCorpusNameInput : Html Msg
viewNewCorpusNameInput =
  div []
    [ input
      [ placeholder "New Corpus Name"
      , onInput ChangeNewCorpusNameInput
      ]
      []
    ]

viewNewCorpusTextInput : Html Msg
viewNewCorpusTextInput =
  div []
    [ input
      [ placeholder "New Corpus Text"
      , onInput ChangeNewCorpusTextInput
      ]
      []
    ]

viewNewCorpusSubmitButtons : Html Msg
viewNewCorpusSubmitButtons =
  div []
    [ button [ onClick SubmitCorpus ] [ text "Submit Corpus" ]
    , button [ onClick ClearCorpus ] [ text "Clear Corpus" ]
    ]

-- DECODERS
type alias GetSprintNameResults =
  { sprint_name : List String }

type alias SubmitResponseResults =
  { sprint_name : List String }

decodeSprintName : Decode.Decoder GetSprintNameResults
decodeSprintName =
  Decode.map
    GetSprintNameResults
    (Decode.at ["sprint_name"] (Decode.list Decode.string))

encodeCorpus : Model -> Http.Body
encodeCorpus model =
  Http.jsonBody
    <| Encode.object [ ("text", Encode.string model.newCorpusText)
                     , ("name", Encode.string model.newCorpusName)
                     ]

decodeSubmitResponse : Decode.Decoder SubmitResponseResults
decodeSubmitResponse =
  Decode.map
    SubmitResponseResults
    (Decode.at ["sprint_name"] (Decode.list Decode.string))

-- HTTP
getSprintName : Cmd Msg
getSprintName =
  let url =
    "http://localhost:4000/corpora/3/sprint-name"
  in
    Http.send NewSprintName (Http.get url decodeSprintName)

submitCorpus : Model -> Cmd Msg
submitCorpus model =
  let url =
    "http://localhost:4000/corpora"
  in
    Http.send NewCorpus (Http.post url (encodeCorpus model) decodeSubmitResponse)
