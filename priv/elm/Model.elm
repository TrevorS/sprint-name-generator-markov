module Model exposing (Model, initialModel)

import Corpus exposing (Corpus)
import Corpora exposing (Corpora)

type alias Model =
  { sprintName : List String
  , newCorpus : Corpus
  , corpora: Corpora
  , selectedCorpus: String
  , errorMessage: String
  , showNewCorpusContainer : Bool
  }

initialModel : Model
initialModel =
  Model [] (Corpus Nothing "" "") [] "" "" False
