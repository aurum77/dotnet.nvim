local M = {}

local utils = require "dotnet.utils"
local nvim_tree_api = require "nvim-tree.api"
local Event = nvim_tree_api.events.Event

function M.setup_nvim_tree()
  M.file_creation_hook()
end

function M.file_creation_hook()
  nvim_tree_api.events.subscribe(Event.FileCreated, function(data)
    local file_path = data.fname
    local file_type
    local file_name
    local namespace = utils.get_file_path_namespace(file_path)

    if file_path:match "[^/]*.cs$" ~= nil then
      file_name = file_path:match("[^/]*.cs$"):gsub(".cs", "")
    end

    if file_path:sub(-3) == ".cs" then
      if file_name:sub(1, 1) == "I" and string.match(file_name:sub(2, 2), "%u") ~= nil then
        file_type = "interface"
      else
        file_type = "class"
      end

      local cs_file = io.open(file_path, "a")
      io.output(cs_file)
      -- Class file
      io.write(
        "namespace "
          .. namespace
          .. ";"
          .. "\n"
          .. "\n"
          .. "public "
          .. file_type
          .. " "
          .. file_name
          .. "\n"
          .. "{\n"
          .. "    \n"
          .. "}\n"
      )
      io.close(cs_file)
    end
  end)
end

return M
