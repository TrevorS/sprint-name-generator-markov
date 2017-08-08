import Html exposing(Html)

import Model exposing (Model, model)
import View exposing(view)

import Corpus exposing (Corpus)

import Msgs exposing (Msg)
import Server exposing (getRandomSprintName, getSprintName, getCorpora, submitCorpus)

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
