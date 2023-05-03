local M = {}

local utils = require "dotnet.utils"
local nvim_tree_api = require "nvim-tree.api"
local Event = nvim_tree_api.events.Event

function M.setup_nvim_tree()
  nvim_tree_api.events.subscribe(Event.FileCreated, function(data)
    local file_path = data.fname
    local file_name = file_path:match("[^/]*.cs$"):gsub(".cs", "")
    local file_type
    local namespace = utils.get_node_namespace()

    if file_path:sub(-3) == ".cs" then
      if file_name:sub(1, 1) == "I" and file_name:sub(1, 2) == file_name:sub(1, 2):upper() then
        vim.notify "interface"
        file_type = "interface"
      else
        vim.notify "class"
        file_type = "class"
      end
      local cs_file = io.open(file_path, "a")
      io.output(cs_file)
      -- Class file
      io.write(
        "using System;\n"
        .. "using System.Collections.Generic;\n"
        .. "using System.Linq;\n"
        .. "using System.Text;"
        .. "\n"
        .. "using System.Threading.Tasks;\n\n"
        .. "namespace "
        .. namespace
        .. "\n"
        .. "{\n"
        .. "    public "
        .. file_type
        .. " "
        .. file_name
        .. "\n"
        .. "    {\n"
        .. "        \n"
        .. "    }\n"
        .. "}"
      )
      io.close(cs_file)
    end
  end)
end

return M
