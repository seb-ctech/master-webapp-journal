module Route.Framework.Name_ exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask exposing (BackendTask)
import BackendTask.File as File
import BackendTask.Glob as Glob
import Effect
import FatalError
import Head
import Html.Styled as Html
import PagesMsg
import RouteBuilder
import Shared
import UrlPath
import Utils exposing (getDocumentedFrameworkNames)
import View



-- This is a Framework specific Route in implements a Stage Based single page compiled from a markdown diary


type alias Model =
    {}


type Msg
    = NoOp


type alias RouteParams =
    { name : String
    }


route : RouteBuilder.StatefulRoute RouteParams Data ActionData Model Msg
route =
    RouteBuilder.preRender
        { data = data
        , pages = pages
        , head = head
        }
        |> RouteBuilder.buildWithSharedState
            { view = view
            , init = init
            , update = update
            , subscriptions = subscriptions
            }


init :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> ( Model, Effect.Effect Msg )
init app shared =
    ( {}, Effect.none )


update :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Msg
    -> Model
    -> ( Model, Effect.Effect Msg, Maybe Shared.Msg )
update app shared msg model =
    case msg of
        NoOp ->
            ( model, Effect.none, Nothing )


subscriptions : RouteParams -> UrlPath.UrlPath -> Shared.Model -> Model -> Sub Msg
subscriptions routeParams path shared model =
    Sub.none


type alias Data =
    String


type alias ActionData =
    {}


data :
    RouteParams
    -> BackendTask FatalError.FatalError Data
data routeParams =
    BackendTask.allowFatal <|
        File.bodyWithoutFrontmatter <|
            (Debug.log "Path to Content:" <|
                "src/frameworks/"
                    ++ routeParams.name
                    -- TODO: Refactor to a smarter solution that picks up directly the path from the glob
                    ++ "/documentation.md"
            )


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head app =
    []


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app shared model =
    { title = "Framework.Name_"
    , body =
        [ Html.h2 [] [ Html.text app.routeParams.name ]

        -- TODO: Parse Markdown into Clean Layout
        -- TODO: Make good styling
        -- TODO: Implement Stage System
        -- TODO: Integrate Audio Files for each stage
        -- TODO: Make Animated Transitions
        , Html.div [] [ Html.text app.data ]
        ]
    }


pages : BackendTask.BackendTask FatalError.FatalError (List RouteParams)
pages =
    getDocumentedFrameworkNames
        |> BackendTask.andThen (\names -> BackendTask.succeed <| List.map RouteParams names)
