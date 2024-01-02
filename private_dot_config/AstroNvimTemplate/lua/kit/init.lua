---@class AndromedaKit: LazyUtilCore
---@field ui AndromedaUIKit
---@field path AndromedaPathKit
---@field root AndromedaRootKit
---@field toggle AndromedaToggleKit
---@field keymap AndromedaKeymapKit
---@field telescope AndromedaTelescopeKit
local M = setmetatable({}, {
  __index = function(t, k)
    if require("lazy.core.util")[k] then return require("lazy.core.util")[k] end
    t[k] = require("kit." .. k)
    return t[k]
  end,
})

--! Plugins

function M.load_plugin(module, key)
  key = key or "config"
  local ok, loaded = pcall(require, module[key])

  if not ok then
    M.error("Error loading " .. module, { title = "Andromeda Plugin Loading" })
    return
  end

  return loaded
end

--! Keymaps

---@alias Mode "'n'" | "'v'" | "'x'" | "'s'" | "'o'" | "'i'" | "'l'" | "'c'" | "'t'" | "'ia'" | "'ca'" | "'!a'"

---@param map_table table
---@param mode? Mode | "all"
function M.add_lazy_mappings(map_table, mode)
  mode = mode or "n"
  local lazy_maps = {}

  if mode == "all" then
    for map_mode, maps in pairs(map_table) do
      for keymap, options in pairs(maps) do
        local cmd = options[1]
        options[1] = nil
        lazy_maps[#lazy_maps + 1] = table.extend({ keymap, cmd }, table.extend(options, { mode = map_mode }))
      end
    end
  else
    for keymap, options in pairs(map_table) do
      local cmd = options[1]
      options[1] = nil
      lazy_maps[#lazy_maps + 1] = table.extend({ keymap, cmd }, table.extend(options, { mode = mode }))
    end
  end

  return lazy_maps
end

return M --[[@as AndromedaKit]]
