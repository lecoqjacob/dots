local Kit = require("kit")
local andromeda = require("andromeda")
local enabled_themes = andromeda.theme.enabled_themes

local colorschemes = {
  { "ray-x/starry.nvim", config = "themes.starry" },
  { "rebelot/kanagawa.nvim", config = "themes.kanagawa" },
  { "olimorris/onedarkpro.nvim", config = "themes.onedark" },
  { "maxmx03/fluoromachine.nvim", config = "themes.fluoromachine" },
  { "craftzdog/solarized-osaka.nvim", config = "themes.solarized_osaka" },
  { "catppuccin/nvim", name = "catppuccin", config = "themes.catppuccin" },
  { "folke/tokyonight.nvim", branch = "main", config = "themes.tokyonight" },
}

colorschemes = table.map(colorschemes, function(_, theme)
  local theme_key = theme.name or require("kit").path.get_filename(theme[1], false)
  local enabled = table.find(enabled_themes, theme_key) ~= nil

  theme = table.extend(theme, {
    lazy = false,
    priority = 1000,
    enabled = enabled,
  }, enabled and Kit.load_plugin(theme) or {})

  return theme
end)

return {
  -- Use this table to try out different colorschemes
  {
    "NvChad/nvim-colorizer.lua",
    event = "User AstroFile",
    opts = { user_default_options = { names = false } },
    keys = { { "<Leader>uz", Kit.toggle.colorizer, desc = "Toggle color highlight" } },
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
  },

  {
    "AstroNvim/astroui",
    dependencies = colorschemes,
    ---@type AstroUIOpts
    opts = {
      colorscheme = andromeda.theme.enabled,
    },
  },
}
