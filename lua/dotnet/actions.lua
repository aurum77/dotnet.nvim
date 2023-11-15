local M = {}

local Job = require "plenary.job"
local utils = require "dotnet.utils"
local constants = require "dotnet.constants"
local notify = require "dotnet.notify"
local jobs = require "dotnet.jobs"
local globals = require "dotnet.globals"

function M.add_project()
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

  vim.ui.select(constants.templates, {
    prompt = "Choose a template:",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if choice then
      if choice.id == "solution" then
        create_new_solution_job:sync(constants.timeout)
        return
      end

      vim.ui.input({
        prompt = "Input the project name:",
      }, function(input)
        if input then
          project_name = input
          template_id = choice.id
          folder = utils.get_node_folder()

          local add_to_solution_job = Job:new {
            command = "dotnet",
            args = { "sln", "add", folder .. project_name },
            on_exit = function(j, return_val)
              notify.write(j:result())
            end,
          }

          if utils.cwd_contains_pattern "./*.sln" then
            jobs.create_new_project_and_then(template_id, project_name, folder, add_to_solution_job)
          else
            create_new_solution_job:sync()
            jobs.create_new_project_and_then(template_id, project_name, folder, add_to_solution_job)
          end
        end
      end)
    end
  end)
end

return M
