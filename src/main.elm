module Login exposing (main)

import Browser
import Browser.Navigation exposing (load)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import Http
import Json.Decode as JD exposing (field, Decoder, int, string)
import Json.Encode as JEncode
import String
import List exposing (head, tail, length)
import Maybe


-- TODO adjust rootUrl as needed


rootUrl =
    "https://mac1xa3.ca/e/patea80/"


-- rootUrl = "https://mac1xa3.ca/e/macid/"

main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }



{- -------------------------------------------------------------------------------------------
   - Model
   -------------------------------------------------------------------------------------------
-}

type alias Model =
    { title : String, price : String, description : String,  
    phnum : String, url : String, date: String, error : String, 
    dubTitle :List String,dubPrice :List String,dubDescription :List String,dubPhnum :List String,dubUrl :List String, dubDate :List String
    , pressed :Bool, 
    addInfo: AddInfo }

{- -------------------------------------------------------------------------------------------
   - Custom type alias for advertisemtn
   -------------------------------------------------------------------------------------------
-}
type alias AddInfo = {
        title : List String, 
        price : List String, 
        description : List String,
        phnum : List String,
        url : List String,
        date : List String
    }

type Msg
    = NewTitle String -- Name text field changed
    | NewPrice String -- Price field
    | NewDescription String -- Description field
    | NewPhnum String -- Phone number field
    | NewUrl String -- Url field
    | NewDate String -- Date field
    | GotJsonInfo (Result Http.Error AddInfo) -- Http Post Response Received
    | AuthResponse (Result Http.Error String) -- Http Post Response Received
    | LogoutResponse (Result Http.Error String) -- Http Post Response Received
    | InfoButton -- Info Button Pressed


init : () -> ( Model, Cmd Msg )
init _ =
    ( { title = ""
      , price = ""
      , description = ""
      , phnum = ""
      , url = ""
      , date = ""
      , error = ""
      , dubTitle = [""]
      , dubPrice = [""]
      , dubDescription = [""]
      , dubPhnum = [""]
      , dubUrl = [""]
      , dubDate = [""]
      , pressed = False
      , addInfo = {title = [], price = [], description = [], phnum = [], url = [], date = []}
      }
    , auth
    )

{- -------------------------------------------------------------------------------------------
   - Header finds first element for list
   -------------------------------------------------------------------------------------------
-}

header : List String -> String 
header xs = 
    case head xs of 
        Just x -> x
        Nothing -> ""

{- -------------------------------------------------------------------------------------------
   - Tailer excludes first element of list 
   -------------------------------------------------------------------------------------------
-}
tailer : List String -> List String
tailer list = 
    case tail list of 
        Just xs -> xs
        Nothing -> [""]

{- -------------------------------------------------------------------------------------------
   - Recursively renders model page
   -------------------------------------------------------------------------------------------
-}
rend : List String -> List String-> List String -> List String-> List String -> List String -> Html msg
rend a b c d e f=
    if length a == 0 then
         div []
            []
    else
        div []
        [ li []
            [ formatList (header a) ("$"++header b) (header c) (header d) (header e) (header f) ]
        , rend (tailer a) (tailer b) (tailer c) (tailer d) (tailer e) (tailer f)
        ] 
    
{- -------------------------------------------------------------------------------------------
   - Adds database values to rendered page
   -------------------------------------------------------------------------------------------
-}
formatList : String ->String ->String ->String -> String -> String-> Html mssg
formatList lt lp ld lph lu lda= div []
    [ img [ alt "", src lu, title "" ]
        []
    , section [ class "list-left" ]
        [ h5 [ class "adprice" ]
            [ text lt ]
        , span [ class "catpath" ]
            [ text ld ]
        , p [ class "catpath" ]
            [ text lda ]
        ]
    , section [ class "list-right" ]
        [ span [ class "catpath"  ]
            [ text lp ]
        , span [ class "catpath" ]
            [ text lph ]
        ]
    , div [ class "clearfix" ]
        []
    ]


{- -------------------------------------------------------------------------------------------
   - Checks for auth
   -------------------------------------------------------------------------------------------
-}     

auth : Cmd Msg
auth = 
    Http.get { 
            url = rootUrl ++ "userauthapp/userinfo/",
            expect = Http.expectString AuthResponse
        }

-- View
view : Model -> Html Msg
view model = div []
    [ node "title" []
        [ text "Resale a Business Category Flat Bootstrap Responsive Website Template | All Classifieds :: w3layouts" ]
    , node "link" [ href "css/bootstrap.min.css", rel "stylesheet" ]
        []
    , node "link" [ href "css/bootstrap-select.css", rel "stylesheet" ]
        []
    , node "link" [ href "css/style.css", media "all", rel "stylesheet", type_ "text/css" ]
        []
    , node "link" [ href "css/jquery-ui1.css", rel "stylesheet", type_ "text/css" ]
        []
    , text ""
    , node "script" [ src "js/jquery.leanModal.min.js", type_ "text/javascript" ]
        []
    , node "link" [ href "css/jquery.uls.css", rel "stylesheet" ]
        []
    , text ""
    , node "link" [ href "css/jquery.uls.grid.css", rel "stylesheet" ]
        []
    , text ""
    , node "link" [ href "css/jquery.uls.lcd.css", rel "stylesheet" ]
        []
    , div [ class "header" ]
        [ div [ class "container" ]
            [ div [ class "logo" ]
                [ a [ href "main.html" ]
                    [ span []
                        [ text "Re" ]
                    , text "sale"
                    ]
                ]
            , div [ class "header-right" ]
                [ a [ class "account", href "project3.html", Events.onClick InfoButton]
                    [ text "Logout" ]
                ]
            ]
        ]
    , div [ class "banner text-center" ]
        [ div [ class "container" ]
            [ h1 []
                [ text "Sell or Advertise   "
                , span [ class "segment-heading" ]
                    [ text "anything online " ]
                , text "with Resale"
                ]
            
            , p []
                [ text "Better than ebay" ]
            , a [ href "post.html" ]
                [ text "Post Free Ad" ]
            ]
        ]
    , div [ class "total-ads main-grid-border" ]
        [ div [ class "container" ]
            [ div [ class "ads-grid" ]
                [ div [ class "ads-display col-md-9" ]
                    [ div [ class "wrapper" ]
                        [ div [ class "bs-example bs-example-tabs", attribute "data-example-id" "togglable-tabs", attribute "role" "tabpanel" ]
                            [ ul [ class "nav nav-tabs nav-tabs-responsive", id "myTab", attribute "role" "tablist" ]
                                [ li [ class "active", attribute "role" "presentation" ]
                                    [ a [ attribute "aria-controls" "home", attribute "aria-expanded" "true", attribute "data-toggle" "tab", href "#home", id "home-tab", attribute "role" "tab" ]
                                        [ span [ class "text" ]
                                            [ text "All Ads" ]
                                        ]
                                    ]
                                , li [ class "next", attribute "role" "presentation" ]
                                    []
                                , li [ attribute "role" "presentation" ]
                                    []
                                ]
                            , div [ class "tab-content", id "myTabContent" ]
                                [ div [ attribute "aria-labelledby" "home-tab", class "tab-pane fade in active", id "home", attribute "role" "tabpanel" ]
                                    [ div []
                                        [ div [ id "container" ]
                                            [ ul [ class "list" ]
                                                [ li []
                                                    [ img [ alt "", src "https://media.giphy.com/media/9JYeYbiHFCSha/giphy.gif", title "" ]
                                                        []
                                                    , section [ class "list-left" ]
                                                        [ h5 [ class "adprice" ]
                                                            [ text "Two bed rooms for sublease on Emerson Street" ]
                                                        , p [ class "catpath" ]
                                                            [ text "Great Home And An Even Greater Lot In This Desirable Neighborhood Located In Downtown Brampton Walking Distance To Gage Park And The Rose Theater. This Home Is Move In Ready For A First Time Home Buyer, Young Professionals Or A Builder Looking To Expand On This Great Lot. Two Sheds Located On Property. " ]
                                                        , p [ class "catpath" ]
                                                            [ text "04/28/2019, 00:43:13" ]
                                                        ]
                                                    , section [ class "list-right" ]
                                                        [ span [class "catpath"  ]
                                                            [ text "$849" ]
                                                        , span [ class "catpath"  ]
                                                            [ text "\n\n\nWendy, weny@properties.com, 416-563-2192" ]
                                                        ]
                                                    , div [ class "clearfix" ]
                                                        []
                                                    ]
                                                , div [ class "clearfix" ]
                                                    []
                                                , rend model.dubTitle model.dubPrice model.dubDescription model.dubPhnum model.dubUrl model.dubDate
                                                ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                , div [ class "clearfix" ]
                    []
                ]
            ]
        ]
    , text "	"
    , footer []
        [ div [ class "footer-top" ]
            []
        , div [ class "footer-bottom text-center" ]
            [ div [ class "container" ]
                [ div [ class "footer-logo" ]
                    []
                , div [ class "copyrights" ]
                    [ p []
                        [ text "© 2019 Resale. All Rights Reserved | Design by  "
                        , a [ href "http://w3layouts.com/" ]
                            [ text "W3layouts" ]
                        ]
                    ]
                , div [ class "clearfix" ]
                    []
                ]
            ]
        ]
    , text ""
    ]
--to check for user input
viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, Events.onInput toMsg ] []


{- -------------------------------------------------------------------------------------------
   - GET request, logs user out
   --------------------------------------------------------------------------------------------
-}

leave : Cmd Msg
leave =
    Http.get
        { url = rootUrl ++ "userauthapp/logout/"
        , expect = Http.expectString LogoutResponse
        }

{- -------------------------------------------------------------------------------------------
   - Update
   -   Sends a JSON Post with currently entered username and password upon button press
   -   Server send an Redirect Response that will automatically redirect to UserPage.html
   -   upon success
   --------------------------------------------------------------------------------------------
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewTitle title ->
            ( { model | title = title }, Cmd.none )
            
        NewPrice price ->
            ( { model | price = price }, Cmd.none )

        NewDescription description ->
            ( { model | description = description }, Cmd.none )
            
    
        NewPhnum phnum ->
            ( { model | phnum = phnum }, Cmd.none )

        NewUrl url ->
            ( { model | url = url }, Cmd.none )
        
        NewDate date ->
            ( { model | date = date }, Cmd.none )

        InfoButton ->
             ( model, leave )
            
        AuthResponse result ->
            case result of
                Ok "LoggedOut" ->
                    ( model, leave )
                Ok "Auth" ->
                    ( model,  getAllAdds)
                Ok _ ->
                    ( model, leave )

                Err error ->
                    ( handleError model error, leave )


        GotJsonInfo result ->
            case result of
                Ok info ->
                    ( { model | dubTitle = info.title, dubPrice = info.price, dubDescription= info.description, dubPhnum = info.phnum, dubUrl = info.url, dubDate = info.date }, Cmd.none )

                Err error ->
                    ( handleError model error, leave )
        LogoutResponse result ->
            case result of
                Ok "LoggedOut" ->
                    ( model, load ("project3.html") )
                Ok _ ->
                    ( model, load ("project3.html") )

                Err error ->
                    ( handleError model error, Cmd.none )

{- -------------------------------------------------------------------------------------------
   - JSON Encode/Decode
   -   Decodes all String Lists for ad properties in JSON from server
   --------------------------------------------------------------------------------------------
-}

infoJsonD : Decoder AddInfo  
infoJsonD = 
    JD.map6 AddInfo  
        (field "title" listDecoder)
        (field "price" listDecoder)
        (field "description" listDecoder)
        (field "phnum" listDecoder)
        (field "url" listDecoder)
        (field "date" listDecoder)

{- -------------------------------------------------------------------------------------------
   - Decodes List String
   --------------------------------------------------------------------------------------------
-}

listDecoder : Decoder (List String)
listDecoder = JD.list JD.string


{- -------------------------------------------------------------------------------------------
   - GET request to getAllAdds in database
   --------------------------------------------------------------------------------------------
-}
getAllAdds : Cmd Msg
getAllAdds =
    Http.get 
        { url = rootUrl ++ "userauthapp/getadds/"
        , expect = Http.expectJson GotJsonInfo infoJsonD
        }

-- put error message in model.error_response (rendered in view)


handleError : Model -> Http.Error -> Model
handleError model error =
    case error of
        Http.BadUrl url ->
            { model | error = "bad url: " ++ url }

        Http.Timeout ->
            { model | error = "timeout" }

        Http.NetworkError ->
            { model | error = "network error" }

        Http.BadStatus i ->
            { model | error = "bad status " ++ String.fromInt i }

        Http.BadBody body ->
            { model | error = "bad body " ++ body }