if vim.g.loaded_dotnet == 1 then
  return
end

vim.g.loaded_dotnet = 1

local commands = require "dotnet.commands"
local nvim_tree = require "dotnet.nvim-tree"
local autocmds = require "dotnet.autocmds"
local api = vim.api

local command = function(name, callback, opts)
  api.nvim_create_user_command(name, callback, opts or {})
end

command("DotnetProject", commands.dotnet_project)
command("DotnetManage", commands.dotnet_manage)

autocmds.register_autocmds()
nvim_tree.setup_nvim_tree()
