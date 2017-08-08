import Html exposing(Html)

import Model exposing (Model, initialModel)
import Msgs exposing (Msg, update, startup)
import View exposing (view)

main : Program Never Model Msg
main =
  Html.program
  { init = (initialModel, startup)
  , view = view
  , update = update
  , subscriptions = \_ -> Sub.none
  }
