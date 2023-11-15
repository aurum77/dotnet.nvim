local M = {}

local constants = require "dotnet.constants"
local notify = require "dotnet.notify"
local actions = require "dotnet.actions"
local jobs = require "dotnet.jobs"

function M.dotnet_manage()
  local projects = jobs.get_projects()

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
      elseif choice.id == "add_reference" then
        actions.add_reference()
        return
      elseif choice.id == "set_debug_project" then
        actions.set_debug_project()
        return
      elseif choice.id == "remove_project" then
        actions.remove_project()
        return
      end
    end
  end)
end

return M
