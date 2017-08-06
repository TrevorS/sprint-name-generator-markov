module Msgs exposing (..)

import Http

import Corpus exposing (Corpus)
import Corpora exposing (Corpora)
import Decoders exposing (GetSprintNameResults)

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
