module Login exposing (main)

import Browser
import Browser.Navigation exposing (load)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as JDecode
import Json.Encode as JEncode
import String
import File exposing (File)



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
   --------------------------------------------------------------------------------------------
-}

type alias Model =
    { title : String, price : String, description : String,  phnum : String, url :String,
    error : String, failed :String, pressed :Bool
    -- ,files:List File
    }


type Msg
    = NewTitle String -- Name text field changed
    | NewPrice String
    | NewDescription String -- Password text field changed
    | NewPhnum String -- Password text field changed
    | NewUrl String -- Password text field changed
    | GotPostResponse (Result Http.Error String) -- Http Post Response Received
    | AuthResponse (Result Http.Error String) -- Http Post Response Received
    | LogoutResponse (Result Http.Error String) -- Http Post Response Received
    | PostButton -- Login Button Pressed
    | LogoutButton -- Login Button Pressed



init : () -> ( Model, Cmd Msg )
init _ =
    ( { title = ""
      , price = ""
      , description = ""
      , phnum = ""
      , url = "data:image/png;base64,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"
      , error = ""
      , failed = "Post Ad!"
      , pressed = False
      }
    , auth
    )
    
auth : Cmd Msg
auth = 
    Http.get { 
            url = rootUrl ++ "userauthapp/userinfo/",
            expect = Http.expectString AuthResponse
        }

-- View
view : Model -> Html Msg
view model = div []
    [ node "link" [ href "css/bootstrap.min.css", rel "stylesheet" ]
        []
    , node "link" [ href "css/bootstrap-select.css", rel "stylesheet" ]
        []
    , node "link" [ href "css/style.css", media "all", rel "stylesheet", type_ "text/css" ]
        []
    , text "				"
    , node "link" [ href "css/jquery.uls.css", rel "stylesheet" ]
        []
    , text "	"
    , node "link" [ href "css/jquery.uls.grid.css", rel "stylesheet" ]
        []
    , text "	"
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
                [ a [ class "account", href "project3.html", Html.Events.onClick LogoutButton]
                    [ text "Logout" ]
                , div [ class "selectregion" ]
                    [ div [ attribute "aria-hidden" "true", attribute "aria-labelledby" "myLargeModalLabel", class "modal fade", id "myModal", attribute "role" "dialog", attribute "tabindex" "-1" ]
                        [ div [ class "modal-dialog modal-lg" ]
                            [ div [ class "modal-content" ]
                                [ div [ class "modal-header" ]
                                    []
                                , div [ class "modal-body" ]
                                    [ Html.form [ class "form-horizontal", attribute "role" "form" ]
                                        [ div [ class "form-group" ]
                                            []
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
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
                [ text "Resale, a community marketplace for all" ]
            , a [ href "post-ad.html" ]
                [ text "Post Free Ad" ]
            ]
        ]
    , div [ class "submit-ad main-grid-border" ]
        [ div [ class "container" ]
            [ h2 [ class "head" ]
                [ text "Post an Ad" ]
            , div [ class "post-ad-form" ]
                [ div []
                    [ label []
                        [ text "Ad Title "
                        , span []
                            [ text "*" ]
                        ]
                    ,div [class "phone",type_ "text"]
                    [ viewInput "title" "Put the title of you add here" model.title NewTitle        
                    ] 
                    , div [ class "clearfix" ]
                        []
                    , label []
                        [ text "Ad Description "
                        , span []
                            [ text "*" ]
                        ]
                    , div [ class "mess",type_ "text"]
                     [viewInput "description" "Write few lines about your product" model.description NewDescription
                     ]
                    , div [ class "clearfix" ]
                        []
                    , div [ class "upload-ad-photos" ]
                        [ label []
                            [ text "Go to https://postimages.org/, 'choose images', upload your image, copy and paste 'direct link'" ]
                        , div [ class "photos-upload-view" ]
                            [ div [ action "main.html", enctype "multipart/form-data", id "upload", method "POST" ]
                                [ input [ id "MAX_FILE_SIZE", name "MAX_FILE_SIZE", type_ "hidden", value "300000" ]
                                    []
                                , div [ class "name" , type_ "text"]
                              [viewInput "" "Direct link goes here" model.url NewUrl
                                ]
                            , div [ class "clearfix" ]
                                []
                                , div [ id "submitbutton" ]
                                    [ a [ href "https://postimages.org/", target "_blank" ]
                                        [ button []
                                            [ text "Take me to Post Images  " ]
                                        ]
                                    ]
                                ]
                            ]
                        , div [ class "clearfix" ]
                            []
                        , node "script" [ src "js/filedrag.js" ]
                            []
                        ]
                    , div [ class "personal-details" ]
                        [ div []
                            [ label []
                                [ text "Price "
                                , span []
                                    [ text "*" ]
                                ]
                            , div [ class "name" , type_ "text"]
                              [viewInput "" "$" model.price NewPrice
                                ]
                            , div [ class "clearfix" ]
                                []
                            , label []
                                [ text "Your Phone Number "
                                , span []
                                    [ text "*" ]
                                ]
                            , div [ class "phone", type_ "text"]
                            [ viewInput "phnumber" "000-000-0000" model.phnum NewPhnum
                            ]
                            , div [ class "clearfix" ]
                                []
                            -- , label []
                            --     [ text "Your Email Address"
                            --     , span []
                            --         [ text "*" ]
                            --     ]
                            -- , input [ class "email", placeholder "", type_ "text" ]
                            --     []
                            -- , div [ class "clearfix" ]
                            --     []
                            , p [ class "post-terms" ]
                                [ text "By clicking "
                                , strong []
                                    [ text "post Button " ]
                                , text "you accept our "
                                , a [ href "https://aarshpatel.com", target "_blank" ]
                                    [ text "Terms of Use " ]
                                , text "and "
                                , a [ href "https://aarshpatel.com", target "_blank" ]
                                    [ text "Privacy Policy" ]
                                ]
                            , input [ type_ "submit",  value model.failed, Html.Events.onClick PostButton ]
                                []
                            , div [ class "clearfix" ]
                                []
                            ]
                        ]
                    ]
                ]
            ]
        , text "		"
        , footer []
            [ div [ class "footer-bottom text-center" ]
                [ div [ class "container" ]
                    [ div [ class "footer-logo" ]
                        [ a [ href "main.html" ]
                            [ span []
                                [ text "Re" ]
                            , text "sale"
                            ]
                        ]
                    , div [ class "footer-social-icons" ]
                        [ ul []
                            [ li []
                                [ a [ class "facebook", href "#" ]
                                    [ span []
                                        [ text "Facebook" ]
                                    ]
                                ]
                            , li []
                                [ a [ class "twitter", href "#" ]
                                    [ span []
                                        [ text "Twitter" ]
                                    ]
                                ]
                            , li []
                                [ a [ class "flickr", href "#" ]
                                    [ span []
                                        [ text "Flickr" ]
                                    ]
                                ]
                            , li []
                                [ a [ class "googleplus", href "#" ]
                                    [ span []
                                        [ text "Google+" ]
                                    ]
                                ]
                            , li []
                                [ a [ class "dribbble", href "#" ]
                                    [ span []
                                        [ text "Dribbble" ]
                                    ]
                                ]
                            ]
                        ]
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
        , text "	"
        ]
    ]

--for user input
viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
    input [ class "phone" ,type_ "text", placeholder p, Html.Events.onInput toMsg ] []



{- -------------------------------------------------------------------------------------------
   - JSON Encode/Decode
   -   Encode Json properties for Ad to be sent to the server
   --------------------------------------------------------------------------------------------
-}


infoEncoder : Model -> JEncode.Value
infoEncoder model =
    JEncode.object
        [ ( "title"
          , JEncode.string model.title
          )
        ,( "price"
          , JEncode.string model.price
          )
        , ( "description"
            , JEncode.string model.description
            )
        , ( "phnum"
            , JEncode.string model.phnum
            )
        , ( "url"
            , JEncode.string model.url
        )
    
        ]

{- -------------------------------------------------------------------------------------------
   - POST request to send info to Django
   --------------------------------------------------------------------------------------------
-}
infoPost : Model -> Cmd Msg
infoPost model =
    Http.post
        { url = rootUrl ++ "userauthapp/postadd/"
        , body = Http.jsonBody <| infoEncoder model
        , expect = Http.expectString GotPostResponse
        }

{- -------------------------------------------------------------------------------------------
   - GET request to logout
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
   -   Sends a JSON Post with currently entered data upon button press
   -   Server send an Redirect Response that will automatically redirect
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

        PostButton ->
         if model.title =="" || model.price =="" || model.description =="" || model.phnum =="" ||model.url ==""  then
                 ( { model | failed = "Please enter all fields" }, Cmd.none )
         else
             ( model, infoPost model )

        LogoutButton ->
             ( model, leave )
            
        AuthResponse result ->
            case result of
                Ok "LoginFailed" ->
                    ( model, leave )
                Ok "Auth" ->
                    ( model,  Cmd.none)
                Ok _ ->
                    ( model, leave )

                Err error ->
                    ( handleError model error, Cmd.none )

        GotPostResponse result ->
            case result of
                Ok "AddPosted" ->
                    ( model, load ("main.html") )
                Ok _ ->
                    ( model, leave )

                Err error ->
                    ( handleError model error, Cmd.none )
        LogoutResponse result ->
            case result of
                Ok "LoggedOut" ->
                    ( model, load ("project3.html") )
                Ok _ ->
                    ( model, load ("project3.html") )

                Err error ->
                    ( handleError model error, Cmd.none )
        


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