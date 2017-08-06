import Html exposing (Html, button, div, input, text, ul, li)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

import Model exposing (Model, model)
import Corpus exposing (Corpus)
import SelectCorpora exposing (selectCorpora)
import Msgs exposing (Msg)
import Server exposing (..)

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
  , Cmd.batch([getRandomSprintName, getCorpora])
  )

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Msgs.GetRandomSprintName ->
      (model, getRandomSprintName)

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

    Msgs.NewSprintName (Err _) ->
      let newModel =
        { model | errorMessage = "NewSprintName: Error" }

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
    [ viewSprintName model.sprintName
    , viewSprintNameButtons model.selectedCorpus
    , selectCorpora model.corpora
    , viewNewCorpusNameInput
    , viewNewCorpusTextInput
    , viewNewCorpusSubmitButtons
    , viewErrors model.errorMessage
    ]

viewSprintName : List String -> Html Msg
viewSprintName sprintName =
  ul []
    (List.map (\word -> li [] [ text word ])
      sprintName)

viewSprintNameButtons : String -> Html Msg
viewSprintNameButtons selectedCorpus =
  div []
    [ button [ onClick (Msgs.GetSprintName selectedCorpus) ] [ text "Get Sprint Name" ]
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

viewErrors : String -> Html Msg
viewErrors errorMessage =
  div [] [ text errorMessage ]
