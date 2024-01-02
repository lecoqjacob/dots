local Kit = require("kit")
local settings = require("andromeda")

---@class AndromedaUIKit
local M = {}

--- Get an icon from the internal icons if it is available and return it
---@param categoryOrKind string The category of icon to retrieve or the icon itself
---@param padding? integer Padding to add to the end of the icon, defaults to 1
---@param wrap? boolean Whether or not to wrap both sides of the icon with spaces
---@return string icon
M.get_icon = function(categoryOrKind, padding, wrap)
  local icons_enabled = vim.g.icons_enabled ~= false
  local icon_pack = assert(require(icons_enabled and "devcons" or "devcons.txt"))

  local icon = icon_pack
  for _, path in ipairs(string.split(categoryOrKind, ".")) do
    icon = icon[path]
  end

  if not icon then return "" end

  -- Wrap the icon in spaces if requested
  local spacing = string.rep(" ", padding or 1)

  if wrap then return spacing .. icon .. spacing end
  return icon .. spacing
end

---@param theme string
M.is_theme_active = function(theme)
  return settings.theme.enabled_themes[theme] ~= nil and theme == settings.theme.enabled
end

---@param theme string
M.set_colorscheme = function(theme)
  Kit.try(function() vim.cmd.colorscheme(theme) end, {
    on_error = function() Kit.notify(("Error setting up colorscheme: `%s`"):format(theme), vim.log.levels.ERROR) end,
  })
end

---@param scheme string
---@param setup_fn? function
---@param activate_theme? boolean
M.activate_colorscheme = function(scheme, setup_fn, activate_theme)
  local active_theme = settings.theme.enabled
  setup_fn = setup_fn or function() require(scheme).setup({}) end

  if active_theme == scheme then
    activate_theme = activate_theme or M.is_theme_active(scheme) or false

    Kit.try(function()
      setup_fn()
      if activate_theme then M.set_colorscheme(scheme) end
    end, {
      on_error = function() Kit.notify(("Error activating colorscheme: `%s`"):format(scheme), vim.log.levels.ERROR) end,
    })
  end
end

function M.info()
  local lines = {} ---@type string[]

  lines = {
    string.format("Colorscheme: %s\nStyle: %s", settings.theme.enabled, settings.theme.style),
    "```lua",
    "vim.g.theme = " .. vim.inspect(settings.theme),
    "```",
  }

  require("kit").info(lines, { title = "Andromeda Colorscheme" })
end

M.setup = function()
  vim.api.nvim_create_user_command(
    "AndromedaTheme",
    function() M.info() end,
    { desc = "Show information about the Andromeda colorscheme" }
  )
end

return M
