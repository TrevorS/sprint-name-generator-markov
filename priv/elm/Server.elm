module Server exposing (..)

import Http

import Model exposing (Model)
import Msgs exposing (Msg)
import Decoders exposing (..)

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
