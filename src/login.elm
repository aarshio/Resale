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
    "http://mac1xa3.ca/e/patea80/"



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
    { name : String, password : String, error : String, failed :String }

type Msg
    = NewName String -- Name text field changed
    | NewPassword String -- Password text field changed
    | GotLoginResponse (Result Http.Error String) -- Http Post Response Received
    | LoginButton -- Login Button Pressed

init : () -> ( Model, Cmd Msg )
init _ =
    ( { name = ""
      , password = ""
      , error = ""
      , failed = ""
      }
    , Cmd.none
    )

-- View
view : Model -> Html Msg
view model = div []
    [ node "link" [ href "css/bootstrap.min.css", rel "stylesheet" ]
        []
    , node "link" [ href "css/bootstrap-select.css", rel "stylesheet" ]
        []
    , node "link" [ href "css/style.css", media "all", rel "stylesheet", type_ "text/css" ]
        []
    , text ""
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
                [ a [ href "index.html" ]
                    [ span []
                        [ text "Re" ]
                    , text "sale"
                    ]
                ]
            , div [ class "header-right" ]
                [ a [ class "account", href "login.html" ]
                    [ text "My Account" ]
                , text "		"
                ]
            ]
        ]
    , section []
        [ div [ class "sign-in-wrapper", id "page-wrapper" ]
            [ div [ class "graphs" ]
                [ div [ class "sign-in-form" ]
                    [ div [ class "sign-in-form-top" ]
                        [ h1 []
                            [ text model.failed ]
                        ]
                    , div [ class "signin" ]
                        [ div [ class "signin-rit" ]
                            []
                    , div []
                            [ div [ class "log-input" ]
                                [ div [ class "log-input-left" ]
                                    [ viewInput "text" "Username" model.name NewName]
                                , div [ class "clearfix" ]
                                    []
                                ]

                              , div [ class "log-input" ]
                                [ div [ class "log-input-left" ] 
                                    [ viewInput "password" "Password" model.password NewPassword ]
                                , div [ class "clearfix" ]
                                    []
                                ]
                            , div []
                                [ input [ type_ "submit", value "Login", Events.onClick LoginButton ]
                                    []
                                ]
                    ]
                        ]
                    , div [ class "new_people" ]
                        [ a [ href "register.html" ]
                            [ text "Register Now!" ]
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
--to check for input
viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, Events.onInput toMsg ] []


{- -------------------------------------------------------------------------------------------
   - JSON Encode/Decode
   -   passwordEncoder turns a model name and password into a JSON value that can be used with
   -   Http.jsonBody
   --------------------------------------------------------------------------------------------
-}

--encodes username and password to send it off to server
passwordEncoder : Model -> JEncode.Value
passwordEncoder model =
    JEncode.object
        [ ( "username"
          , JEncode.string model.name
          )
        , ( "password"
          , JEncode.string model.password
          )
        ]
--post request to login
loginPost : Model -> Cmd Msg
loginPost model =
    Http.post
        { url = rootUrl ++ "userauthapp/loginuser/"
        , body = Http.jsonBody <| passwordEncoder model
        , expect = Http.expectString GotLoginResponse
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
        NewName name ->
            ( { model | name = name }, Cmd.none )

        NewPassword password ->
            ( { model | password = password }, Cmd.none )


        LoginButton ->
            if model.name == "" || model.password == ""  then
                ( { model | failed = "Please enter the required fields" }, Cmd.none )
            else
                ( model, loginPost model )

        GotLoginResponse result ->
            case result of
                Ok "LoginFailed" ->
                    ( { model | error = "failed to login", failed = "Incorrect username or password, try again :(" }, Cmd.none )

                Ok "READY" ->
                    ( model, load "main.html" )

                Ok _ ->
                     ( { model | error = "failed to login", failed = "Something went wrong:(" }, Cmd.none )

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
