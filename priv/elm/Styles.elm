module Styles exposing(..)

type alias Styles = List (String, String)

viewStyles : Styles
viewStyles =
  [ ("line-height", "1.4")
  , ("font-family", "futura-medium, cursive")
  , ("height", "100vh")
  , ("background-color", "#E4DEE8")
  ]

h1Styles : Styles
h1Styles =
  [ ("font-size", "40px")
  , ("text-align", "center")
  , ("margin-top", "0")
  , ("padding-top", "50px")
  , ("font-weight", "500")
  , ("color", "#DD4669")
  ]

sprintNameStyles: Styles
sprintNameStyles =
  [ ("font-size", "30px")
  , ("text-align", "right")
  , ("padding-right", "40px")
  ]

liStyles : Styles
liStyles =
  [ ("list-style-type", "none")
  , ("display", "inline")
  , ("padding-right", "20px")
  ]

getSprintNameStyles : Styles
getSprintNameStyles =
  [ ("text-align", "right")
  , ("padding-right", "60px")
  ]

buttonStyles : Styles
buttonStyles =
  [ ("padding", "10px")
  , ("font-size", "15px")
  , ("background", "white")
  , ("border", "none")
  , ("border-radius", "3px")
  , ("cursor", "pointer")
  ]

selectCorporaStyles : Styles
selectCorporaStyles =
  [ ("font-size", "15px")
  , ("height", "39px")
  , ("border", "none")
  , ("border-radius", "3px")
  , ("margin-right", "20px")
  , ("width", "185px")
  , ("text-align-last", "right")
  ]

selectCorporaOptionStyles : Styles
selectCorporaOptionStyles =
  [ ("direction", "rtl")
  ]
