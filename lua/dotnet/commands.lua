local M = {}

local Job = require "plenary.job"
local utils = require "dotnet.utils"
local templates = require("dotnet.templates").get_templates()
local notify = require "dotnet.notify"

-- DotnetNew
function M.dotnet_project()
  local template_id
  local project_name
  local folder

  local create_new_solution_job = Job:new {
    command = "dotnet",
    args = { "new", "solution" },
    on_exit = function(j, return_val)
      notify.write(j:result())
    end,
  }

  vim.ui.select(templates, {
    prompt = "Choose a template:",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if choice then
      if choice.id == "solution" then
        create_new_solution_job:sync()
        return
      end

      vim.ui.input({
        prompt = "Input the project name:",
      }, function(input)
        if input then
          project_name = input
          template_id = choice.id
          folder = utils.get_node_folder()

          local create_new_project_job = Job:new {
            command = "dotnet",
            cwd = folder,
            args = { "new", template_id, "-n", project_name },
            on_exit = function(j, return_val)
              notify.write(j:result())
            end,
          }

          local add_to_solution_job = Job:new {
            command = "dotnet",
            args = { "sln", "add", folder .. project_name },
            on_exit = function(j, return_val)
              notify.write(j:result())
            end,
          }

          if utils.cwd_contains_pattern "./*.sln" then
            create_new_project_job:and_then(add_to_solution_job)
            create_new_project_job:sync()
          else
            create_new_solution_job:sync()
            create_new_project_job:and_then(add_to_solution_job)
            create_new_project_job:sync()
          end
        end
      end)
    end
  end)
end

return M
