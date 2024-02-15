module Utils exposing (getDocumentedFrameworkNames)

import BackendTask
import BackendTask.Glob as Glob
import FatalError



-- FIXME: Multiple Glob Matches cause duplicates, Glob library has solution for that


getDocumentedFrameworkNames : BackendTask.BackendTask FatalError.FatalError (List String)
getDocumentedFrameworkNames =
    Glob.succeed (\s -> s)
        |> Glob.match (Glob.literal "src/frameworks/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal "/")
        |> Glob.match Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask
