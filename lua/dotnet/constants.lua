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
    { name = "ASP.NET Core Empty",                           id = "web" },
    { name = "ASP.NET Core gRPC Service",                    id = "grpc" },
    { name = "ASP.NET Core Web API",                         id = "webapi" },
    { name = "ASP.NET Core Web App",                         id = "razor" },
    { name = "ASP.NET Core Web App (Model-View-Controller)", id = "mvc" },
    { name = "ASP.NET Core with Angular",                    id = "angular" },
    { name = "ASP.NET Core with React.js",                   id = "react" },
    { name = "Blazor Server App",                            id = "blazorserver" },
    { name = "Blazor WebAssembly App",                       id = "blazorwasm" },
    { name = "Class Library",                                id = "classlib" },
    { name = "Console App",                                  id = "console" },
    { name = "dotnet gitignore file",                        id = "gitignore" },
    { name = "Dotnet local tool manifest file",              id = "tool-manifest" },
    { name = "EditorConfig file",                            id = "editorconfig" },
    { name = "global.json file",                             id = "globaljson" },
    { name = "MSTest Test Project",                          id = "mstest" },
    { name = "MVC ViewImports",                              id = "viewimports" },
    { name = "MVC ViewStart",                                id = "viewstart" },
    { name = "NuGet Config",                                 id = "nugetconfig" },
    { name = "NUnit 3 Test Item",                            id = "nunit-test" },
    { name = "NUnit 3 Test Project",                         id = "nunit" },
    { name = "Protocol Buffer File",                         id = "proto" },
    { name = "Razor Class Library",                          id = "razorclasslib" },
    { name = "Razor Component",                              id = "razorcomponent" },
    { name = "Razor Page",                                   id = "page" },
    { name = "Solution File",                                id = "solution" },
    { name = "Web Config",                                   id = "webconfig" },
    { name = "Worker Service",                               id = "worker" },
    { name = "xUnit Test Project",                           id = "xunit" },
  }
end

return m
