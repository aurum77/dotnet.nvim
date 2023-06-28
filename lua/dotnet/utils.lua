local M = {}

local scan = require "plenary.scandir"
local notify = require "dotnet.notify"
local nvim_tree_api = require "nvim-tree.api"

function M.tbl_contains_pattern(t, pattern)
  vim.validate { t = { t, "t" } }

  for _, v in ipairs(t) do
    if string.match(v, pattern) then
      return true
    end
  end
  return false
end

function M.cwd_contains_pattern(pattern)
  local dir = scan.scan_dir(".", { hidden = true, depth = 1 })

  local result = M.tbl_contains_pattern(dir, pattern)

  return result
end

function M.is_directory(path)
  if vim.fn.isdirectory(path) == 1 then
    return true
  else
    return false
  end
end

function M.get_node_namespace()
  local node = nvim_tree_api.tree.get_node_under_cursor()
  local cwd = vim.fn.getcwd()
  local project
  local dir

  if not M.is_directory(node.absolute_path) then
    node = node.parent
  end

  local node_tmp = node

  -- Get project path
  if node ~= nil then
    while true do
      dir = scan.scan_dir(node.absolute_path, { hidden = true, depth = 1 })

      if M.tbl_contains_pattern(dir, ".*.csproj") then
        project = node
        break
      end

      if node.absolute_path == cwd then
        return cwd
      end

      node = node.parent
    end

    if project and node_tmp then
      return node_tmp.absolute_path:gsub(project.parent.absolute_path, ""):sub(2):gsub("/", ".")
    else
      notify.write("Failed to find parent project", notify.ERROR)
      return cwd
    end
  else
    notify.write("Failed to find parent project", notify.ERROR)
    return cwd
  end
end

function M.get_parent_directory(path)
  local directory
  local split = path:match "/[^/]*$"

  if split ~= nil then
    directory = path:gsub(split, "")
  end

  return directory
end

function M.get_file_path_namespace(file_path)
  local path = file_path
  local path_tmp
  local cwd = vim.fn.getcwd()
  local project
  local project_parent
  local dir

  path = M.get_parent_directory(path)
  path_tmp = path

  -- Get project path
  if file_path ~= nil then
    while true do
      dir = scan.scan_dir(path, { hidden = true, depth = 1 })

      if M.tbl_contains_pattern(dir, ".*.csproj") then
        project = path
        break
      end

      if path == cwd then
        return cwd
      end

      path = M.get_parent_directory(path)
    end

    if project and path_tmp then
      project_parent = M.get_parent_directory(project)

      print(path_tmp:gsub(project_parent, ""):sub(2):gsub("/", "."))
      return path_tmp:gsub(project_parent, ""):sub(2):gsub("/", ".")
    else
      notify.write("Failed to find parent project", notify.ERROR)
      return cwd
    end
  else
    notify.write("Failed to find parent project", notify.ERROR)
    return cwd
  end
end

function M.get_node_folder()
  local node = nvim_tree_api.tree.get_node_under_cursor()

  if M.is_directory(node.absolute_path) then
    return node.absolute_path .. "/"
  else
    return node.parent.absolute_path .. "/"
  end
end

return M
