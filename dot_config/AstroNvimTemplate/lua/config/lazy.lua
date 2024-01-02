local andromeda = require("andromeda")

local vim_path = Globals.vim_path
local data_dir = Globals.data_dir
local modules_dir = vim_path .. "/lua/modules"
local lazy_path = data_dir .. "lazy/lazy.nvim"
local plugin_dir = modules_dir .. "/plugins/*.lua"

local Lazy = {
  modules = {},
  dev_patterns = {},
}

function Lazy:append_nativertp()
  ---@diagnostic disable-next-line: undefined-global
  package.path = package.path
    .. string.format(
      ";%s;%s;%s;",
      modules_dir .. "/?.lua",
      modules_dir .. "/?/init.lua",
      modules_dir .. "/configs/?.lua"
    )
end

function Lazy:init_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    -- stylua: ignore
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
  end
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

  if vim.env.LAZY then table.insert(self.dev_patterns, "lazy.nvim") end

  Lazy:append_nativertp()
end

function Lazy:get_plugins()
  local list = {}

  local plugins_list = vim.split(vim.fn.glob(plugin_dir), "\n")
  for _, f in ipairs(plugins_list) do
    list[#list + 1] = f:find(modules_dir) and f:sub(#modules_dir - 6, -1)
  end

  return list
end

function Lazy:initialize_andromeda() require("kit.ui").setup() end

function Lazy:load_plugins()
  local function merge(conf)
    if conf.merge ~= nil then conf = vim.tbl_extend("force", conf, conf.merge) end
    return conf
  end

  self.modules = {
    { "AstroNvim/AstroNvim", branch = "v4", import = "astronvim.plugins" },
    { "AstroNvim/astrocommunity", branch = "v4" },
  }

  --! Disable plugins
  for _, plugin in ipairs(andromeda.plugin.disabled) do
    self.modules[#self.modules + 1] = { plugin, enabled = false }
  end

  --! loop over settings.plugins.xtras
  for _, plugin in ipairs(andromeda.plugin.xtras) do
    self.modules[#self.modules + 1] = { import = "astrocommunity." .. plugin }
  end

  --! Enable community plugins
  for _, m in ipairs(Lazy:get_plugins()) do
    local modules = require(m:sub(0, #m - 4))
    local has_multiple_modules = #modules > 1

    if has_multiple_modules then
      for _, conf in ipairs(modules) do
        self.modules[#self.modules + 1] = merge(conf)
      end
    else
      self.modules[#self.modules + 1] = merge(modules)
    end
  end
end

function Lazy:load_lazy()
  self:init_lazy()
  self:load_plugins()

  -- local icons = require("devcons")
  -- local ui_sep = require("devcons").ui.get

  ---@class LazyConfig
  local lazy_opts = {
    checker = { enabled = true },
    change_detection = { enabled = true },
    dev = { patterns = self.dev_patterns },
    defaults = { lazy = true, version = false },
    -- install = { missing = true, colorscheme = andromeda.theme.enabled_themes },

    ui = {
      wrap = true, -- wrap the lines in the ui
      -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
      -- border = andromeda.ui.float.border,

      -- icons = {
      --   cmd = icons.misc.Code,
      --   start = icons.ui.Play,
      --   config = icons.ui.Gear,
      --   event = icons.ui.Event,
      --   init = icons.misc.ManUp,
      --   loaded = icons.ui.Check,
      --   keys = icons.ui.Keyboard,
      --   runtime = icons.misc.Vim,
      --   plugin = icons.ui.Package,
      --   ft = icons.documents.Files,
      --   source = icons.misc.Source,
      --   not_loaded = icons.misc.Ghost,
      --   import = icons.documents.Import,

      --   list = {
      --     ui_sep("Square"),
      --     ui_sep("BigCircle"),
      --     ui_sep("ChevronRight"),
      --     ui_sep("BigUnfilledCircle"),
      --   },
      -- },
    },

    performance = {
      rtp = {
        -- disable some rtp plugins
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          -- "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  }

  if Globals.is_mac then lazy_opts.concurrency = 20 end

  require("lazy")--[[@as Lazy]]
    .setup(self.modules, lazy_opts)

  Lazy:initialize_andromeda()
end

Lazy:load_lazy()
