import Html exposing (Html, button, div, input, text, ul, li, span)
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
  ( model
  , getSprintName
  )

-- MODEL
type alias Corpus =
  { id: Maybe Int
  , name: String
  , text: String
  }

type alias Corpora = List Corpus

type alias Model =
  { sprintName : List String
  , newCorpus : Corpus
  , corpora: Corpora
  , errorMessage: String
  }

model : Model
model =
  Model [] (Corpus Nothing "" "") [] ""

-- UPDATE
type Msg
  = GetSprintName
  | ClearSprintName
  | NewSprintName (Result Http.Error GetSprintNameResults)
  | ChangeNewCorpusTextInput String
  | ChangeNewCorpusNameInput String
  | SubmitCorpus
  | NewCorpus (Result Http.Error Corpus)
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
      let newModel =
        { model | errorMessage = "Error" }

      in
        (newModel, Cmd.none)

    ChangeNewCorpusTextInput inputText ->
      let
        corpus =
          model.newCorpus

        newCorpus =
          { corpus | text = inputText }

        newModel =
        { model | newCorpus = newCorpus }

      in
        (newModel, Cmd.none)

    ChangeNewCorpusNameInput inputText ->
      let
        corpus =
          model.newCorpus

        newCorpus =
          { corpus | name = inputText }

        newModel =
        { model | newCorpus = newCorpus }

      in
        (newModel, Cmd.none)

    SubmitCorpus ->
      (model, submitCorpus model)

    ClearCorpus ->
      let newModel =
        { model | newCorpus = Corpus Nothing "" ""}

      in
        (newModel, Cmd.none)

    NewCorpus (Ok results) ->
      let newModel =
        { model | corpora = results :: model.corpora }

      in
        (newModel, Cmd.none)

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
    , viewErrors model
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

viewErrors : Model -> Html Msg
viewErrors model =
  div [] [ text model.errorMessage ]

-- DECODERS
type alias GetSprintNameResults =
  { sprint_name : List String }

decodeSprintName : Decode.Decoder GetSprintNameResults
decodeSprintName =
  Decode.map
    GetSprintNameResults
    (Decode.at ["sprint_name"] (Decode.list Decode.string))

encodeCorpus : Model -> Http.Body
encodeCorpus model =
  Http.jsonBody
    <| Encode.object
      [
        ("corpus", Encode.object
          [ ("text", Encode.string model.newCorpus.text)
          , ("name", Encode.string model.newCorpus.name)
          ]
        )
      ]

decodeSubmitResponse : Decode.Decoder Corpus
decodeSubmitResponse =
  Decode.map3 Corpus
    (Decode.maybe <| Decode.field "id" Decode.int)
    (Decode.field "name" Decode.string)
    (Decode.field "text" Decode.string)

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
