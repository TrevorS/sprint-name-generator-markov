import Html exposing (Html, button, div, input, select, option, text, label, ul, li, span)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http

import Corpus exposing (Corpus)
import Corpora exposing (Corpora)
import SelectCorpora exposing (selectCorpora)
import Msgs exposing (Msg)
import Decoders exposing (..)

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
  , Cmd.batch([(getSprintName "3"), getCorpora])
  )

-- MODEL
type alias Model =
  { sprintName : List String
  , newCorpus : Corpus
  , corpora: Corpora
  , selectedCorpus: String
  , errorMessage: String
  }

model : Model
model =
  Model [] (Corpus Nothing "" "") [] "" ""

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Msgs.GetSprintName corpusId ->
      (model, getSprintName corpusId)

    Msgs.ClearSprintName ->
      let newModel =
        { model | sprintName = [] }

      in
        (newModel, Cmd.none)

    Msgs.CorporaSelected results ->
      let newModel =
        { model | selectedCorpus = results }

      in
        (newModel, Cmd.none)

    Msgs.NewSprintName (Ok results) ->
      let newModel =
        { model | sprintName = results.sprint_name }

      in
        (newModel, Cmd.none)

    Msgs.GetCorpora (Ok results) ->
      let newModel =
        { model | corpora = results }

      in
        (newModel, Cmd.none)

    Msgs.GetCorpora (Err _) ->
      let newModel =
        { model | errorMessage = "GetCorpora: Error" }

      in
        (newModel, Cmd.none)

    Msgs.NewSprintName (Err _) ->
      let newModel =
        { model | errorMessage = "NewSprintName: Error" }

      in
        (newModel, Cmd.none)

    Msgs.ChangeNewCorpusTextInput inputText ->
      let
        corpus =
          model.newCorpus

        newCorpus =
          { corpus | text = inputText }

        newModel =
        { model | newCorpus = newCorpus }

      in
        (newModel, Cmd.none)

    Msgs.ChangeNewCorpusNameInput inputText ->
      let
        corpus =
          model.newCorpus

        newCorpus =
          { corpus | name = inputText }

        newModel =
        { model | newCorpus = newCorpus }

      in
        (newModel, Cmd.none)

    Msgs.SubmitCorpus ->
      (model, submitCorpus model)

    Msgs.ClearCorpus ->
      let newModel =
        { model | newCorpus = Corpus Nothing "" ""}

      in
        (newModel, Cmd.none)

    Msgs.NewCorpus (Ok results) ->
      let newModel =
        { model | corpora = results :: model.corpora }

      in
        (newModel, Cmd.none)

    Msgs.NewCorpus (Err error) ->
      Debug.crash("error: " ++ (toString error))

      (model, Cmd.none)

-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ viewSprintName model
    , viewSprintNameButtons
    , selectCorpora model.corpora
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
    [ button [ onClick (Msgs.GetSprintName "3") ] [ text "Get Sprint Name" ]
    , button [ onClick Msgs.ClearSprintName ] [ text "Clear" ]
    ]

viewNewCorpusNameInput : Html Msg
viewNewCorpusNameInput =
  div []
    [ input
      [ placeholder "New Corpus Name"
      , onInput Msgs.ChangeNewCorpusNameInput
      ]
      []
    ]

viewNewCorpusTextInput : Html Msg
viewNewCorpusTextInput =
  div []
    [ input
      [ placeholder "New Corpus Text"
      , onInput Msgs.ChangeNewCorpusTextInput
      ]
      []
    ]

viewNewCorpusSubmitButtons : Html Msg
viewNewCorpusSubmitButtons =
  div []
    [ button [ onClick Msgs.SubmitCorpus ] [ text "Submit Corpus" ]
    , button [ onClick Msgs.ClearCorpus ] [ text "Clear Corpus" ]
    ]

viewErrors : Model -> Html Msg
viewErrors model =
  div [] [ text model.errorMessage ]

-- HTTP
getSprintName : String -> Cmd Msg
getSprintName corpusId =
  let url =
    "http://localhost:4000/corpora/" ++ corpusId ++ "/sprint-name"
  in
    Http.send Msgs.NewSprintName (Http.get url decodeSprintName)

getCorpora : Cmd Msg
getCorpora =
  let url =
    "http://localhost:4000/corpora"
  in
    Http.send Msgs.GetCorpora (Http.get url decodeCorpora)

submitCorpus : Model -> Cmd Msg
submitCorpus model =
  let url =
    "http://localhost:4000/corpora"
  in
    Http.send Msgs.NewCorpus (Http.post url (encodeCorpus model.newCorpus) decodeCorpus)
