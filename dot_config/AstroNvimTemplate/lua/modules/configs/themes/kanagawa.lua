local settings = require("andromeda")
local themes = { "wave", "dragon", "lotus" }
local theme = table.find(themes, settings.theme.style) or "dragon"

return {
  config = function()
    require("kit.ui").activate_colorscheme(
      "kanagawa",
      function()
        require("kanagawa").setup({
          theme = theme,
          transparent = settings.theme.enable_transparent,
        })
      end
    )
  end,
}
