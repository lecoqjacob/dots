local settings = require("andromeda")

local themes = {
  "darker",
  "darksolar",
  "deepocean",
  "dracula",
  "dracula_blood",
  "earlysummer",
  "emerald",
  "limestone",
  "mariana",
  "monokai",
  "moonlight",
  "oceanic",
  "palenight",
  "starry",
  "ukraine",
}

local theme = table.find(themes, settings.theme.style) or "moonlight"

return {
  config = function()
    require("kit.ui").activate_colorscheme("starry", function()
      require("starry").setup({
        style = { name = theme },
        -- disable = { background = settings.theme.enable_transparent },
      })
    end)
  end,
}
