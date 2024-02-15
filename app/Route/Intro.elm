module Route.Intro exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import Effect
import FatalError
import Head
import Html.Styled as Html
import PagesMsg
import RouteBuilder
import Shared
import UrlPath
import View



-- Intro is what the viewer sees when he is past the Index as a little prelude to the actual site. It explains the Process and how it is structured


type alias Model =
    {}


type Msg
    = NoOp


type alias RouteParams =
    {}


route : RouteBuilder.StatefulRoute RouteParams Data ActionData Model Msg
route =
    RouteBuilder.single { data = data, head = head }
        |> RouteBuilder.buildWithLocalState
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
    -> ( Model, Effect.Effect Msg )
update app shared msg model =
    case msg of
        NoOp ->
            ( model, Effect.none )


subscriptions : RouteParams -> UrlPath.UrlPath -> Shared.Model -> Model -> Sub Msg
subscriptions routeParams path shared model =
    Sub.none


type alias Data =
    { message : String
    }


type alias ActionData =
    {}


data : BackendTask.BackendTask FatalError.FatalError Data
data =
    BackendTask.succeed Data
        |> BackendTask.andMap
            -- TODO: Load Single Page Texts from Source Files aswell, maybe put source files into a 'content' directory instead
            (BackendTask.succeed "The following Webapp presents you a selection of Haskell Frameworks. \n Each Framework has been explored in terms of it's abstraction of musical concepts \n By following Musical Exercises from the Book Music: Art and Craft we build an ever increasingly advanced vocabulary of composition concepts \nand apply them in a self-reflective creative exploration structured in stages,\nwhere each stage represents a level of abstraction in terms of a composition exercise.\nWith each following stage we attempt a jump of abstraction to follow the complexity of the exercises.\nDuring this process three things can happen. The abstraction from the framework matches that of the exercise. And we can observe the translation of one concept into its syntactical counterpart.\nThe abstraction does not match the level of complexity of the exercise. In which case the missing abstraction is implemented in terms of simpler abstractions.\nThe far more interesting outcome, is when an abstraction exists to support the required level of complexity but in terms of different semantics.\nIt is in this case that we can observe how the divergence in abstractions, of the mental model can influence decisions in the creative process and explore to what results this influence leads.\nThis should give a glimpse into how language impacts thoughts, and what role abstraction plays in the process of cognition. All of this while following a compositional process across different implementations.\nThis journey starts from here...")


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head app =
    []


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app shared model =
    { title = "Intro", body = [ Html.h2 [] [ Html.text app.data.message ] ] }
