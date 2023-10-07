local M = {}

function M.register_autocmds()
  local dotnet_group = vim.api.nvim_create_augroup("DotnetGroup", {})
  local dotnet = require "dotnet"

  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = dotnet_group,
    pattern = { "*.cs", "*.sln" },
    once = true,
    callback = dotnet.start,
  })
end

return M
