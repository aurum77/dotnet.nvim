local M = {}

local Job = require "plenary.job"
local notify = require "dotnet.notify"
local constants = require "dotnet.constants"

function M.get_projects()
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

  return projects
end

function M.create_new_project(template_id, project_name, folder)
  local create_new_project_job = Job:new {
    command = "dotnet",
    cwd = folder,
    args = { "new", template_id, "-n", project_name },
    on_exit = function(j, return_val)
      notify.write(j:result())
    end,
  }

  create_new_project_job:sync(constants.timeout)
end

function M.create_new_project_and_then(template_id, project_name, folder, and_then_job)
  local create_new_project_job = Job:new {
    command = "dotnet",
    cwd = folder,
    args = { "new", template_id, "-n", project_name },
    on_exit = function(j, return_val)
      notify.write(j:result())
    end,
  }

  create_new_project_job:and_then(and_then_job)
  create_new_project_job:sync(constants.timeout)
end

function M.add_to_solution(folder, project_name)
  local add_to_solution_job = Job:new {
    command = "dotnet",
    args = { "sln", "add", folder .. project_name },
    on_exit = function(j, return_val)
      notify.write(j:result())
    end,
  }

  add_to_solution_job:sync(constants.timeout)
end

function M.add_reference(to, of)
  local add_reference_job = Job:new {
    command = "dotnet",
    args = { "add", to, "reference", of },
    on_exit = function(j, return_val)
      notify.write(j:result())
    end,
  }

  add_reference_job:sync(constants.timeout)
end

function M.remove_from_solution(csproj_path)
  local remove_project_job = Job:new {
    command = "dotnet",
    args = { "sln", "remove", csproj_path },
    on_exit = function(j, return_val)
      notify.write(j:result())
    end,
  }

  remove_project_job:sync(constants.timeout)
end

function M.remove_reference(from, of)
  local split = vim.fn.split(from, "/")
  table.remove(split, #split)

  local cwd = table.concat(split, "/")
  cwd = "/" .. cwd

  local remove_reference_job = Job:new {
    command = "dotnet",
    args = { "remove", from, "reference", of },
    cwd = cwd,
    on_exit = function(j, return_val)
      notify.write(j:result())
    end,
  }

  remove_reference_job:sync(constants.timeout)
end

function M.get_references(csproj)
  local references

  local get_references_job = Job:new {
    command = "dotnet",
    args = { "list", csproj, "reference" },
    on_exit = function(j, return_val)
      references = j:result()
    end,
  }

  get_references_job:sync(constants.timeout)

  -- no references found
  if #references == 1 then
    return {}
  end

  table.remove(references, 1)
  table.remove(references, 1)

  for key, value in pairs(references) do
    references[key] = references[key]:gsub("\\", "/")
  end

  return references
end

return M
