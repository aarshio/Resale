module Login exposing (main)

import Browser
import Browser.Navigation exposing (load)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import Http
import Json.Decode as JDecode
import Json.Encode as JEncode
import String



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
    { fullname : String, email : String, name : String, password : String, confirmPass : String, error : String, failed :String }


type Msg
    =   NewFullName String
    | NewEmail String
    | NewName String -- Name text field changed
    | NewPassword String -- Password text field changed
    | NewConfirmPass String
    | GotLoginResponse (Result Http.Error String) -- Http Post Response Received
    | LoginButton -- Login Button Pressed




init : () -> ( Model, Cmd Msg )
init _ =
    ( { 
        fullname = ""
        , email = ""
        , name = ""
        , password = ""
        , confirmPass = ""
        , error = ""
        , failed = ""
      }
    , Cmd.none
    )

-- View
view : Model -> Html Msg
view model = div []
    [ node "title" []
        [ text "Resale " ]
    , node "link" [ href "css/bootstrap.min.css", rel "stylesheet" ]
        []
    , node "link" [ href "css/bootstrap-select.css", rel "stylesheet" ]
        []
    , node "link" [ href "css/style.css", media "all", rel "stylesheet", type_ "text/css" ]
        []
    , text ""
    , text "	"
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
                [ a [ href "project3.html" ]
                    [ span []
                        [ text "Re" ]
                    , text "sale"
                    ]
                ]
            , div [ class "header-right" ]
                [ a [ class "account", href "project3.html" ]
                    [ text "Log in" ]
                , text "		"
                ]
            ]
        ]
    , section []
        [ div [ class "sign-in-wrapper", id "page-wrapper" ]
            [ div [ class "graphs" ]
                [ div [ class "sign-up" ]
                    [ h1 []
                        [ text model.failed ]
                    , h2 []
                        [ text "Personal Information" ]

                    , div [ class "sign-u" ]
                        [ div [ class "sign-up1" ]
                            [ h4 []
                                [ text "Full Name* :" ]
                            ]
                        , div [ class "sign-up2" ]
                            [ div []
                                [ viewInput "text" "Enter your first and last name" model.fullname NewFullName]
                            ]
                        , div [ class "clearfix" ]
                            []
                        ]


                    , div [ class "sign-u" ]
                        [ div [ class "sign-up1" ]
                            [ h4 []
                                [ text "Username* :" ]
                            ]
                        , div [ class "sign-up2" ]
                            [ div []
                                [ viewInput "text" "Username" model.name NewName]
                            ]
                        , div [ class "clearfix" ]
                            []
                        ]

                        , div [ class "sign-u" ]
                        [ div [ class "sign-up1" ]
                            [ h4 []
                                [ text "Email* :" ]
                            ]
                        , div [ class "sign-up2" ]
                            [ div []
                                [ viewInput "text" "Email address" model.email NewEmail]
                            ]
                        , div [ class "clearfix" ]
                            []
                        ]
                        
                    , div [ class "sign-u" ]
                        [ div [ class "sign-up1" ]
                            [ h4 []
                                [ text "Password* :" ]
                            ]
                        , div [ class "sign-up2" ]
                            [ div []
                                [ viewInput "password" "Password" model.password NewPassword ]
                            ]
                        , div [ class "clearfix" ]
                            []
                        ]
                    , div [ class "sign-u" ]
                        [ div [ class "sign-up1" ]
                            [ h4 []
                                [ text "Password Again* :" ]
                            ]
                        , div [ class "sign-up2" ]
                            [ div []
                                [ div []
                                [ viewInput "password" "Type your password again" model.confirmPass NewConfirmPass ]
                            ]
                            ]
                        , div [ class "clearfix" ]
                            []
                        ]
                    , div [ class "sub_home" ]
                        [ div [ class "sub_home_left" ]
                            [ div []
                                [ input [ type_ "submit", value "Sign up", Events.onClick LoginButton ]
                                    []
                                ]
                            ]
                        , div [ class "clearfix" ]
                            []
                        ]
                    ]
                ]
            ]
        , footer [ class "diff" ]
            [ p [ class "text-center" ]
                [ text "2019 Resale. All Rights Reserved | Design by "
                , a [ href "https://w3layouts.com/", target "_blank" ]
                    [ text "w3layouts." ]
                ]
            ]
        , text "	"
        ]
    ]

viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, Events.onInput toMsg ] []


{- -------------------------------------------------------------------------------------------
   - JSON Encode/Decode
   -   passwordEncoder turns a model name and password into a JSON value that can be used with
   -   Http.jsonBody
   --------------------------------------------------------------------------------------------
-}


passwordEncoder : Model -> JEncode.Value
passwordEncoder model =
    JEncode.object
        [ 
          ( "fullname"
          , JEncode.string model.fullname
          )
        , ( "email"
          , JEncode.string model.email
          )
        , ( "username"
          , JEncode.string model.name
          )
        , ( "password"
          , JEncode.string model.password
          )
        ]

loginPost : Model -> Cmd Msg
loginPost model =
    Http.post
        { url = rootUrl ++ "userauthapp/adduser/"
        , body = Http.jsonBody <| passwordEncoder model
        , expect = Http.expectString GotLoginResponse
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
        NewFullName fullname ->
            ( { model | fullname = fullname }, Cmd.none )
        
        NewEmail email ->
            ( { model | email = email }, Cmd.none )

        NewName name ->
            ( { model | name = name }, Cmd.none )

        NewPassword password ->
            ( { model | password = password }, Cmd.none )
    
        NewConfirmPass confirmPass ->
            ( { model | confirmPass = confirmPass }, Cmd.none )

        LoginButton ->
            if model.password /= model.confirmPass then
                 ( { model | failed = "Passwords do not match :(" }, Cmd.none )
            else if model.fullname == "" || model.email == "" ||model.name == "" || model.password == "" || model.confirmPass == "" then
                ( { model | failed = "Please enter the required fields" }, Cmd.none )
            else
                ( model, loginPost model )


        GotLoginResponse result ->
            case result of
                Ok "LoginFailed" ->
                    ( { model | error = "failed to login", failed = "Login failed, try again :(" }, Cmd.none )
                
                Ok "Exsists" ->
                    ( { model | error = "failed to login", failed = "Username already taken :(" }, Cmd.none )

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
