local m = {}

---@class template
---@type string name
---@type string id

-- 10 seconds, in miliseconds
m.timeout = 10000

function m.get_templates()
  -- stylua: ignore
  ---@type template[]
  return {
    { name = "asp.net core empty",                           id = "web" },
    { name = "asp.net core grpc service",                    id = "grpc" },
    { name = "asp.net core web api",                         id = "webapi" },
    { name = "asp.net core web app",                         id = "razor" },
    { name = "asp.net core web app (model-view-controller)", id = "mvc" },
    { name = "asp.net core with angular",                    id = "angular" },
    { name = "asp.net core with react.js",                   id = "react" },
    { name = "blazor server app",                            id = "blazorserver" },
    { name = "blazor webassembly app",                       id = "blazorwasm" },
    { name = "class library",                                id = "classlib" },
    { name = "console app",                                  id = "console" },
    { name = "dotnet gitignore file",                        id = "gitignore" },
    { name = "dotnet local tool manifest file",              id = "tool-manifest" },
    { name = "editorconfig file",                            id = "editorconfig" },
    { name = "global.json file",                             id = "globaljson" },
    { name = "mstest test project",                          id = "mstest" },
    { name = "mvc viewimports",                              id = "viewimports" },
    { name = "mvc viewstart",                                id = "viewstart" },
    { name = "nuget config",                                 id = "nugetconfig" },
    { name = "nunit 3 test item",                            id = "nunit-test" },
    { name = "nunit 3 test project",                         id = "nunit" },
    { name = "protocol buffer file",                         id = "proto" },
    { name = "razor class library",                          id = "razorclasslib" },
    { name = "razor component",                              id = "razorcomponent" },
    { name = "razor page",                                   id = "page" },
    { name = "solution file",                                id = "solution" },
    { name = "web config",                                   id = "webconfig" },
    { name = "worker service",                               id = "worker" },
    { name = "xunit test project",                           id = "xunit" },
  }
end

return m
