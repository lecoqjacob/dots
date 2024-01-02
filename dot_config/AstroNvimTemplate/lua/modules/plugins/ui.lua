return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = require("ui.dashboard"),
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "rcarriga/nvim-notify",
    opts = function(_, opts) opts.background_colour = "#000000" end,
  },
}
