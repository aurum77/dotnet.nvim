local M = {}

local Job = require "plenary.job"
local constants = require "dotnet.constants"
local notify = require "dotnet.notify"
local actions = require "dotnet.actions"

function M.dotnet_manage()
  local projects

  local get_projects_job = Job:new {
    command = "dotnet",
    args = { "sln", "list" },
    on_exit = function(j, return_val)
      projects = j:result()
    end,
  }

  get_projects_job:sync(constants.timeout)

  table.remove(projects, 1)
  table.remove(projects, 1)

  vim.ui.select(constants.management, {
    prompt = "Choose Action:",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if choice then
      if choice.id == "add_project" then
        actions.add_project()
        return
      end
      notify.write(choice.name)
      vim.ui.select(projects, {
        prompt = "Choose Project:",
      }, function(choice)
        if choice then
          notify.write(choice)
        end
      end)
    end
  end)
end

return M
