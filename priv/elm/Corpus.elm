module Corpus exposing (Corpus)

type alias Corpus =
  { id: Maybe Int
  , name: String
  , text: String
  }
