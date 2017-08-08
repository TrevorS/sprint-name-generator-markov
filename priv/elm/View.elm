module View exposing (view)

import Html exposing (Html, button, div, input, text, ul, li)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (onClick, onInput)

import Model exposing (Model)
import Msgs exposing (Msg)
import SelectCorpora exposing (selectCorpora)

view : Model -> Html Msg
view model =
  div []
    [ viewSprintName model.sprintName
    , viewSprintNameButtons model.selectedCorpus
    , selectCorpora model.corpora
    , viewNewCorpusNameInput
    , viewNewCorpusTextInput
    , viewNewCorpusSubmitButtons
    , viewErrors model.errorMessage
    ]

viewSprintName : List String -> Html Msg
viewSprintName sprintName =
  ul []
    (List.map (\word -> li [] [ text word ])
      sprintName)

viewSprintNameButtons : String -> Html Msg
viewSprintNameButtons selectedCorpus =
  div []
    [ button [ onClick (Msgs.GetSprintName selectedCorpus) ] [ text "Get Sprint Name" ]
    , button [ onClick Msgs.ClearSprintName ] [ text "Clear" ]
    ]

viewNewCorpusNameInput : Html Msg
viewNewCorpusNameInput =
  div []
    [ input
      [ placeholder "New Corpus Name"
      , onInput Msgs.ChangeNewCorpusNameInput
      ]
      []
    ]

viewNewCorpusTextInput : Html Msg
viewNewCorpusTextInput =
  div []
    [ input
      [ placeholder "New Corpus Text"
      , onInput Msgs.ChangeNewCorpusTextInput
      ]
      []
    ]

viewNewCorpusSubmitButtons : Html Msg
viewNewCorpusSubmitButtons =
  div []
    [ button [ onClick Msgs.SubmitCorpus ] [ text "Submit Corpus" ]
    , button [ onClick Msgs.ClearCorpus ] [ text "Clear Corpus" ]
    ]

viewErrors : String -> Html Msg
viewErrors errorMessage =
  div [] [ text errorMessage ]
