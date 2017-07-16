module Main exposing (..)

import Disco exposing (..)
import Html


type alias Store =
    { todo : List String
    , otherThing : String
    }


type alias SubStore =
    { first : String
    , second : String
    }


q :
    { items : Query Store (List String)
    , intro : Query Store String
    , foo : Query Store SubStore
    }
q =
    { items = .todo >> List.reverse
    , intro = .otherThing
    , foo =
        \store ->
            { first = store.todo |> List.head |> Maybe.withDefault "bar"
            , second = "nope"
            }
    }


view : View Store msg
view =
    with q.items <|
        \items ->
            div []
                [ ul [] <| List.map (renderTodo >> List.singleton >> li []) items
                , split q.foo subView
                ]


renderTodo : String -> View Store msg
renderTodo item =
    with q.intro <|
        \intro ->
            div []
                [ text intro
                , text item
                ]


subView : View SubStore msg
subView =
    with identity <|
        \{ first, second } ->
            div []
                [ text <| "first: " ++ first
                , text <| "second: " ++ second
                ]


init : ( Store, Cmd msg )
init =
    { todo = [ "hello", "world" ]
    , otherThing = "hi"
    }
        ! []


main =
    Html.program
        { init = init
        , update = \_ store -> store ! []
        , view = render view
        , subscriptions = always Sub.none
        }