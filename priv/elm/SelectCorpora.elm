module SelectCorpora exposing (selectCorpora)

import Html exposing (Html, div, label, option, select, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

import Corpora exposing (Corpora)
import Msgs exposing (Msg)

selectCorpora : Corpora -> Html Msg
selectCorpora corpora =
  div []
    [ label []
      [ select [ onInput Msgs.CorporaSelected ] (options corpora)
      , text "Choose Corpora"
      ]
    ]

options : Corpora -> List (Html Msg)
options corpora =
  (List.map (\corpus -> option [value (idToString corpus.id)] [text corpus.name])
    corpora)

idToString : Maybe Int -> String
idToString id =
  case id of
    Just value ->
      toString value

    Nothing ->
      Debug.crash "selectCorpora: received Corpus without `id`."
