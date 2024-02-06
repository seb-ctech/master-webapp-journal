module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import BackendTask exposing (BackendTask)
import Css exposing (..)
import Effect exposing (Effect)
import FatalError exposing (FatalError)
import Html exposing (Html)
import Html.Styled exposing (toUnstyled)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import UrlPath exposing (UrlPath)
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Nothing
    }


type Msg
    = SharedMsg SharedMsg
    | NextStage Int
    | SwitchFramework String


type alias StyledPage msg =
    { body : List (Html msg)
    , title : String
    }


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { framework : String
    , progressStage : Int
    }


init :
    Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : UrlPath
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Effect Msg )
init flags maybePagePath =
    ( { framework = "something"
      , progressStage = 0
      }
    , Effect.none
    )


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        SharedMsg globalMsg ->
            ( model, Effect.none )

        NextStage offset ->
            ( { model | progressStage = model.progressStage + offset }, Effect.none )

        SwitchFramework name ->
            ( { model | framework = name }, Effect.none )



-- TODO: Find a way to integrate the Framework switch with the idioms provided by the framework
-- type Msg =


subscriptions : UrlPath -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : BackendTask FatalError Data
data =
    BackendTask.succeed ()


frameworkNav : List String -> Html.Styled.Html Msg
frameworkNav fws =
    Html.Styled.ul
        [ css
            [ displayFlex
            , flexDirection row
            , listStyle none
            ]
        ]
        (List.map
            (\name ->
                Html.Styled.li
                    [ css
                        [ margin (px 5) ]
                    ]
                    [ Html.Styled.button [ onClick (SwitchFramework name) ] [ Html.Styled.text name ]
                    ]
            )
            fws
        )


view :
    Data
    ->
        { path : UrlPath
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> StyledPage msg
view sharedData page model toMsg pageView =
    { body =
        List.map toUnstyled <|
            [ Html.Styled.div
                []
                [ Html.Styled.map toMsg <| frameworkNav [ "TidalCycles", "Euterpea", "Kulitta" ]
                , Html.Styled.h1 [] [ Html.Styled.text ("You are looking at -> " ++ model.framework) ]
                ]
            , Html.Styled.div [] pageView.body
            ]
    , title = pageView.title
    }
