module Decoders exposing (..)

import Http
import Json.Decode as Decode
import Json.Encode as Encode

import Corpus exposing (Corpus)
import Corpora exposing (Corpora)

type alias GetSprintNameResults =
  { sprint_name : List String }

decodeSprintName : Decode.Decoder GetSprintNameResults
decodeSprintName =
  Decode.map
    GetSprintNameResults
    (Decode.at ["sprint_name"] (Decode.list Decode.string))

encodeCorpus : Corpus -> Http.Body
encodeCorpus newCorpus =
  Http.jsonBody
    <| Encode.object
      [
        ("corpus", Encode.object
          [ ("text", Encode.string newCorpus.text)
          , ("name", Encode.string newCorpus.name)
          ]
        )
      ]

decodeCorpus : Decode.Decoder Corpus
decodeCorpus =
  Decode.map3 Corpus
    (Decode.maybe <| Decode.field "id" Decode.int)
    (Decode.field "name" Decode.string)
    (Decode.field "text" Decode.string)

decodeCorpora : Decode.Decoder Corpora
decodeCorpora =
  Decode.list decodeCorpus
