local function better_search(key)
  return function()
    local searched, error =
      pcall(vim.cmd.normal, { args = { (vim.v.count > 0 and vim.v.count or "") .. key }, bang = true })
    if not searched and type(error) == "string" then require("astrocore").notify(error, vim.log.levels.ERROR) end
  end
end

return {
  {
    "AstroNvim/astroui",
    opts = function(_, opts) opts.icons = table.extend(opts.icons, require("devcons")) end,
  },

  {
    "AstroNvim/astrocore",
    opts = {
      -- modify core features of AstroNvim
      features = {
        cmp = true, -- enable completion at start
        autopairs = true, -- enable autopairs at start
        highlighturl = true, -- highlight URLs at start
        notifications = true, -- enable notifications at start
        max_file = { size = 1024 * 100, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      },

      autocmds = {
        auto_spell = {
          {
            event = "FileType",
            desc = "Enable wrap and spell for text like documents",
            pattern = { "gitcommit", "markdown", "text", "plaintex" },
            callback = function()
              vim.opt_local.wrap = true
              vim.opt_local.spell = true
            end,
          },
        },

        autohide_tabline = {
          {
            event = "User",
            desc = "Auto hide tabline",
            pattern = "AstroBufsUpdated",
            callback = function()
              local new_showtabline = #vim.t.bufs > 1 and 2 or 1
              if new_showtabline ~= vim.opt.showtabline:get() then vim.opt.showtabline = new_showtabline end
            end,
          },
        },
      },

      mappings = {
        n = {
          n = { better_search("n"), desc = "Next search" },
          N = { better_search("N"), desc = "Previous search" },
        },
      },
    },
  },
}
