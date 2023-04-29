local M = {}

local Job = require "plenary.job"
local utils = require "dotnet.utils"
local templates = require "dotnet.templates".get_templates()

-- DotnetNew
function M.dotnet_new()
  local template_id
  local project_name

  vim.ui.select(templates, {
    prompt = "Choose a template:",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if choice then
      if choice.id ~= "solution" then
        vim.ui.input({
          prompt = "Input the project name:",
        }, function(input)
          if input then
            project_name = input
            template_id = choice.id
            local create_new_project_job = Job:new {
              command = "dotnet",
              args = { "new", template_id, "-n", project_name },
              on_exit = function(j, return_val)
                vim.notify(j:result())
              end,
            }

            if utils.pwd_contains_pattern("./*.sln") then
              local add_to_solution = Job:new {
                command = "dotnet",
                args = { "sln", "add", project_name },
                on_exit = function(j, return_val)
                  vim.notify(j:result())
                end,
              }
              create_new_project_job:and_then(add_to_solution)
              create_new_project_job:sync()
              return
            else
              create_new_project_job:sync()
            end
          end
        end)
      else
        local new_solution_job = Job:new {
          command = "dotnet",
          args = { "new", "solution" },
          on_stdout = function(_, line)
            vim.notify(line)
          end,
        }

        new_solution_job:sync()
      end
    end
  end)
end

return M
