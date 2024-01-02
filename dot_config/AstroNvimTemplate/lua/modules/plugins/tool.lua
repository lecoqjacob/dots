local andromeda = require("andromeda")
local telescope_ext = require("kit.telescope")
local enabled_extensions = andromeda.plugin.telescope_extensions

local telescope_extensions = table.reduce(telescope_ext.available_extensions, function(acc, ext, extension)
  if table.find(enabled_extensions, ext.extension) ~= nil then
    acc[#acc + 1] = { ext[1], config = function() telescope_ext.load_telescope_plugin(ext.extension) end }
  end
end, {})

return {
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    lazy = true,
    dependencies = { { "junegunn/fzf", build = ":call fzf#install()" } },
    opts = { preview = { border = "single", wrap = true, winblend = 0 } },
  },

  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    version = false,
    cmd = "Telescope",
    config = require("tools.telescope"),
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", telescope_extensions },
  },
}
