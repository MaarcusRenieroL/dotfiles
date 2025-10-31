local plugins = {}

local function load_from(dir)
  local path = string.format("maarcus.plugins.%s", dir)
  local ok, items = pcall(require, path)
  if ok and type(items) == "table" then
    vim.list_extend(plugins, items)
  end
end

-- List of all plugin categories
local categories = { "ui", "lsp", "navigation", "git", "misc" }

for _, category in ipairs(categories) do
  local ok, _ = pcall(require, "maarcus.plugins." .. category .. ".init")
  if not ok then
    for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/maarcus/plugins/" .. category)) do
      if file:match("%.lua$") then
        table.insert(plugins, require("maarcus.plugins." .. category .. "." .. file:gsub("%.lua$", "")))
      end
    end
  end
end

return plugins
