module Model exposing (Model, model)

import Corpus exposing (Corpus)
import Corpora exposing (Corpora)

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
