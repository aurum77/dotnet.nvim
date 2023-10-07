local M = {}

local commands = require "dotnet.commands"
local nvim_tree = require "dotnet.nvim-tree"
local autocmds = require "dotnet.autocmds"
local api = vim.api

local command = function(name, callback, opts)
  api.nvim_create_user_command(name, callback, opts or {})
end

if vim.g.loaded_dotnet == 1 then
  return
end

function M.setup()
  nvim_tree.setup_nvim_tree()
  command("DotnetProject", commands.dotnet_project)
  command("DotnetManage", commands.dotnet_manage)
end

return M
