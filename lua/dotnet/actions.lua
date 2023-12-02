local M = {}

local Job = require "plenary.job"
local utils = require "dotnet.utils"
local constants = require "dotnet.constants"
local notify = require "dotnet.notify"
local jobs = require "dotnet.jobs"
local globals = require "dotnet.globals"

function M.add_project()
  local template_id
  local project_name
  local folder

  local create_new_solution_job = Job:new {
    command = "dotnet",
    args = { "new", "solution" },
    on_exit = function(j, return_val)
      notify.write(j:result())
    end,
  }

  vim.ui.select(constants.templates, {
    prompt = "Choose a template:",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if choice then
      if choice.id == "solution" then
        create_new_solution_job:sync(constants.timeout)
        return
      end

      vim.ui.input({
        prompt = "Input the project name:",
      }, function(input)
        if input then
          project_name = input
          template_id = choice.id
          folder = utils.get_node_folder()

          local add_to_solution_job = Job:new {
            command = "dotnet",
            args = { "sln", "add", folder .. project_name },
            on_exit = function(j, return_val)
              notify.write(j:result())
            end,
          }

          if utils.cwd_contains_pattern "./*.sln" then
            jobs.create_new_project_and_then(template_id, project_name, folder, add_to_solution_job)
          else
            create_new_solution_job:sync()
            jobs.create_new_project_and_then(template_id, project_name, folder, add_to_solution_job)
          end
        end
      end)
    end
  end)
end

function M.add_reference()
  local projects = jobs.get_projects()
  local to
  local of

  vim.ui.select(projects, {
    prompt = "Add reference to:",
  }, function(choice)
    if choice then
      local chosen_project_index = utils.get_element_index(projects, choice)
      to = choice

      table.remove(projects, chosen_project_index)

      vim.ui.select(projects, {
        prompt = "Add reference of:",
      }, function(choice)
        if choice then
          of = choice

          jobs.add_reference(to, of)
        end
      end)
    end
  end)
end

function M.set_debug_project()
  local dlls = utils.get_debug_dlls()
  local split

  vim.ui.select(dlls, {
    prompt = "Choose DLL:",
    format_item = function(item)
      split = vim.fn.split(item, "/")
      return split[#split]
    end,
  }, function(choice)
    if choice then
      globals.DEBUG_PROJECT = choice
      notify.write("Debug Project is set to: " .. globals.DEBUG_PROJECT)
    else
      notify.write "No Debug Projects picked"
    end
  end)
end

function M.remove_from_solution()
  local csproj_paths = utils.get_projects()
  local split

  vim.ui.select(csproj_paths, {
    format_item = function(item)
      split = vim.fn.split(item, "/")
      return split[#split]
    end,
  }, function(choice)
    if choice then
      jobs.remove_from_solution(choice)
    end
  end)
end

function M.remove_reference()
  local csproj_paths = utils.get_projects()
  local split
  local references

  vim.ui.select(csproj_paths, {
    format_item = function(item)
      split = vim.fn.split(item, "/")
      return split[#split]
    end,
  }, function(from)
    if from then
      references = jobs.get_references(from)
      if #references == 0 then
        notify.write("No references found in project " .. from)
        return
      end

      vim.ui.select(references, {}, function(of)
        if of then
          jobs.remove_reference(from, of)
        end
      end)
    end
  end)
end

return M
