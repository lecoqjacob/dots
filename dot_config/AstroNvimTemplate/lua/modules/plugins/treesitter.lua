local andromeda = require("andromeda")

local treesitter_ctx = {}
if andromeda.plugin.enable_treesitter_context then
  treesitter_ctx = {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = true,
    event = "User AstroFile",
    cmd = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
    opts = { max_lines = 3, mode = "cursor" },
    keys = {
      {
        "<leader>ut",
        function()
          local Util = require("lazyvim.util")
          local tsc = require("treesitter-context")
          tsc.toggle()
          if Util.inject.get_upvalue(tsc.toggle, "enabled") then
            Util.info("Enabled Treesitter Context", { title = "Option" })
          else
            Util.warn("Disabled Treesitter Context", { title = "Option" })
          end
        end,
        desc = "Toggle Treesitter Context",
      },
    },
  }
end

local deps = {
  treesitter_ctx,
  {
    "windwp/nvim-ts-autotag",
    opts = { enable_close_on_slash = false },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
      local configs = require("nvim-treesitter.configs")

      for name, fn in pairs(move) do
        if name:find("goto") == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "User AstroFile", "VeryLazy" },
    cmd = {
      "TSBufDisable",
      "TSBufEnable",
      "TSBufToggle",
      "TSDisable",
      "TSEnable",
      "TSToggle",
      "TSInstall",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },

    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      -- CODE FROM LazyVim (thanks folke!) https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,

    dependencies = deps,

    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      indent = { enable = true },
      autotag = { enable = true },

      highlight = {
        enable = true,
        disable = function(_, bufnr) return vim.b[bufnr].large_buf end,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          scope_incremental = false,
          node_decremental = "<bs>",
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
        },
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["al"] = { query = "@loop.outer", desc = "around loop" },
            ["il"] = { query = "@loop.inner", desc = "inside loop" },
            ["ak"] = { query = "@block.outer", desc = "around block" },
            ["ik"] = { query = "@block.inner", desc = "inside block" },
            ["ac"] = { query = "@class.outer", desc = "around class" },
            ["ic"] = { query = "@class.inner", desc = "inside class" },
            ["af"] = { query = "@function.outer", desc = "around function " },
            ["if"] = { query = "@function.inner", desc = "inside function " },
            ["aa"] = { query = "@parameter.outer", desc = "around argument" },
            ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
            ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
            ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
          },
        },

        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]k"] = { query = "@block.outer", desc = "Next block start" },
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
          },
          goto_next_end = {
            ["]K"] = { query = "@block.outer", desc = "Next block end" },
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
            ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
          },
          goto_previous_start = {
            ["[k"] = { query = "@block.outer", desc = "Previous block start" },
            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
            ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
          },
          goto_previous_end = {
            ["[K"] = { query = "@block.outer", desc = "Previous block end" },
            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
            ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
          },
        },

        swap = {
          enable = true,
          swap_next = {
            [">K"] = { query = "@block.outer", desc = "Swap next block" },
            [">F"] = { query = "@function.outer", desc = "Swap next function" },
            [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
          },
          swap_previous = {
            ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
            ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
            ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
          },
        },
      },
    },

    config = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, andromeda.plugin.treesitter_ensure_installed)

      if type(opts.ensure_installed) == "table" then
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(parser)
          if added[parser] then return false end
          added[parser] = true
          return true
        end, opts.ensure_installed)
      end

      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
