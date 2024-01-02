-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = "williamboman/mason.nvim",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsStartingInstall",
        callback = function()
          vim.schedule(function() print("mason-tool-installer is starting") end)
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsUpdateCompleted",
        callback = function(e)
          vim.schedule(function()
            print(vim.inspect(e.data)) -- print the table that lists the programs that were installed
          end)
        end,
      })
    end,
    config = function()
      require("mason-tool-installer").setup({
        run_on_start = false,
        ensure_installed = require("andromeda").plugin.formatters_and_linters,
      })

      vim.defer_fn(vim.cmd.MasonToolsInstall, 2000)
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function() end,
  },

  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>F",
        function()
          require("conform").format({ lsp_fallback = "always" })
          vim.cmd.update()
        end,
        mode = { "n", "x" },
        desc = " Format & Save",
      },
    },
  },
}
