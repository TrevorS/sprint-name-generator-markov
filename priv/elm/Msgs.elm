module Msgs exposing (..)

import Http

import Model exposing (Model)
import Corpus exposing (Corpus)
import Corpora exposing (Corpora)
import Decoders exposing (GetSprintNameResults, decodeSprintName, decodeCorpora, decodeCorpus ,encodeCorpus)

type Msg
  = GetRandomSprintName
  | GetSprintName String
  | GetCorpora (Result Http.Error Corpora)
  | ClearSprintName
  | NewSprintName (Result Http.Error GetSprintNameResults)
  | ChangeNewCorpusTextInput String
  | ChangeNewCorpusNameInput String
  | SubmitCorpus
  | NewCorpus (Result Http.Error Corpus)
  | ClearCorpus
  | CorporaSelected String

startup : Cmd Msg
startup =
  Cmd.batch
    [ getRandomSprintName
    , getCorpora
    ]

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetRandomSprintName ->
      (model, getRandomSprintName)

    GetSprintName corpusId ->
      (model, getSprintName corpusId)

    ClearSprintName ->
      let newModel =
        { model | sprintName = [] }

      in
        (newModel, Cmd.none)

    CorporaSelected results ->
      let newModel =
        { model | selectedCorpus = results }

      in
        (newModel, Cmd.none)

    NewSprintName (Ok results) ->
      let newModel =
        { model | sprintName = results.sprint_name }

      in
        (newModel, Cmd.none)

    NewSprintName (Err _) ->
      let newModel =
        { model | errorMessage = "NewSprintName: Error" }

      in
        (newModel, Cmd.none)

    GetCorpora (Ok results) ->
      let newModel =
        { model | corpora = results }

      in
        (newModel, Cmd.none)

    GetCorpora (Err _) ->
      let newModel =
        { model | errorMessage = "GetCorpora: Error" }

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

getRandomSprintName : Cmd Msg
getRandomSprintName =
  let url =
    "http://localhost:4000/sprint-name"
  in
    Http.send NewSprintName (Http.get url decodeSprintName)

getSprintName : String -> Cmd Msg
getSprintName corpusId =
  let url =
    "http://localhost:4000/corpora/" ++ corpusId ++ "/sprint-name"
  in
    Http.send NewSprintName (Http.get url decodeSprintName)

getCorpora : Cmd Msg
getCorpora =
  let url =
    "http://localhost:4000/corpora"
  in
    Http.send GetCorpora (Http.get url decodeCorpora)

submitCorpus : Model -> Cmd Msg
submitCorpus model =
  let url =
    "http://localhost:4000/corpora"
  in
    Http.send NewCorpus (Http.post url (encodeCorpus model.newCorpus) decodeCorpus)
