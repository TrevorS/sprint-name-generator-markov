module View exposing (view)

import Html exposing (Html, h1, label, select, option, button, div, input, text, ul, li)
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (onClick, onInput)

import Model exposing (Model)
import Msgs exposing (Msg)
import Corpora exposing (Corpora)

import Styles exposing (..)

view : Model -> Html Msg
view model =
  div [style viewStyles] [container model]

container : Model -> Html Msg
container model =
  div [style containerStyles]
    [ title
    , sprintName model.sprintName
    , getSprintName model.selectedCorpus model.corpora
    , newCorpusContainer model.showNewCorpusContainer model.errorMessage
    ]

title : Html Msg
title =
  div []
    [h1 [style h1Styles] [text "Random Sprint Name Generator"]]

sprintName : List String -> Html Msg
sprintName sprintName =
  div [style sprintNameStyles]
    [ul []
      (List.map (\word -> li [style liStyles] [ text word ])
        sprintName)
    ]

getSprintName : String -> Corpora -> Html Msg
getSprintName selectedCorpus corpora =
  div [style getSprintNameStyles]
    [ selectCorpora corpora
    , getSprintNameButton selectedCorpus
    ]

getSprintNameButton : String -> Html Msg
getSprintNameButton selectedCorpus =
  button [ style buttonStyles, onClick (Msgs.GetSprintName selectedCorpus) ] [ text "Get Sprint Name" ]

selectCorpora : Corpora -> Html Msg
selectCorpora corpora =
  select [ style selectCorporaStyles, onInput Msgs.CorporaSelected ] (selectCorporaOptions corpora)

selectCorporaOptions : Corpora -> List (Html Msg)
selectCorporaOptions corpora =
  (List.map (\corpus -> option [style selectCorporaOptionStyles, value (idToString corpus.id)] [text corpus.name])
    corpora)

idToString : Maybe Int -> String
idToString id =
  case id of
    Just value ->
      toString value

    Nothing ->
      Debug.crash "selectCorpora: received Corpus without `id`."

newCorpusContainer : Bool -> String -> Html Msg
newCorpusContainer showNewCorpusContainer errorMessage =
  div [style (newCorpusContainerStyles showNewCorpusContainer)]
    [ newCorpusNameInput
    , newCorpusTextInput
    , newCorpusSubmitButtons
    , errors errorMessage
    ]

newCorpusNameInput : Html Msg
newCorpusNameInput =
  div []
    [ input
      [ placeholder "New Corpus Name"
      , onInput Msgs.ChangeNewCorpusNameInput
      ]
      []
    ]

newCorpusTextInput : Html Msg
newCorpusTextInput =
  div []
    [ input
      [ placeholder "New Corpus Text"
      , onInput Msgs.ChangeNewCorpusTextInput
      ]
      []
    ]

newCorpusSubmitButtons : Html Msg
newCorpusSubmitButtons =
  div []
    [ button [ onClick Msgs.SubmitCorpus ] [ text "Submit Corpus" ]
    , button [ onClick Msgs.ClearCorpus ] [ text "Clear Corpus" ]
    ]

errors : String -> Html Msg
errors errorMessage =
  div [] [ text errorMessage ]
