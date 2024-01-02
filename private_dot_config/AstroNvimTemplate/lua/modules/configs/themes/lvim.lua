local settings = require("andromeda")

return {
  style = settings.theme.style, -- dark, darksoft, light

  styles = {
    variables = {},
    comments = { italic = true, bold = true },
    keywords = { italic = true, bold = true },
    functions = { italic = true, bold = true },
  },

  colors = {
    dark = {},
    light = {},
    darksoft = {},
  },

  sidebars = {
    "qf",
    "pqf",
    "dbui",
    "packer",
    "Outline",
    "terminal",
    "calendar",
    "neo-tree",
    "ctrlspace",
    "spectre_panel",
  },

  config = function(_, opts)
    require("kit.ui").activate_colorscheme("lvim", function() require("lvim").setup(opts) end, true)
  end,
}
