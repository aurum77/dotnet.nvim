local M = {}

local constants = require "dotnet.constants"
local actions = require "dotnet.actions"

function M.dotnet_manage()
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
      elseif choice.id == "add_to_solution" then
        actions.remove_package()
        return
      elseif choice.id == "remove_from_solution" then
        actions.remove_project()
        return
      elseif choice.id == "remove_package" then
        actions.remove_package()
        return
      elseif choice.id == "remove_reference" then
        actions.remove_reference()
        return
      elseif choice.id == "set_debug_project" then
        actions.set_debug_project()
        return
      end
      return
    end
  end)
end

return M
