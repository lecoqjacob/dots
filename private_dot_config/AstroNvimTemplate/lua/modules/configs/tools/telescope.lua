local andromeda = require("andromeda")
local telescope_ext = require("kit.telescope")
local enabled_extensions = andromeda.plugin.telescope_extensions

local filter_configs = function(configs)
  return table.reduce(configs, function(acc, ext, extension)
    if table.find(enabled_extensions, extension) ~= nil then
      acc[#acc + 1] = { [extension] = type(ext) == "function" and ext() or ext }
    end
  end, {})
end

return function()
  require("telescope")--[[@as Telescope]]
    .setup({
      defaults = {
        color_devicons = true,
        prompt_prefix = require("devcons").get("Telescope", 2),
        selection_caret = require("devcons").get("Selected", 1),

        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,

        layout_config = {
          width = 0.85,
          height = 0.92,
          preview_cutoff = 120,
          vertical = { mirror = false },
          horizontal = { prompt_position = "top", preview_width = 0.55, results_width = 0.8 },
        },

        vimgrep_arguments = {
          "rg",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--trim",
          andromeda.plugin.telescope_grep_hidden and "--hidden" or "",
        },
      },

      extensions = filter_configs({
        aerial = {
          show_lines = false,
          show_nesting = {
            ["_"] = false, -- This key will be the default
            lua = true, -- You can set the option for specific filetypes
          },
        },

        fzf = {
          fuzzy = false,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },

        frecency = {
          use_sqlite = false,
          show_scores = true,
          show_unindexed = true,
          ignore_patterns = { "*.git/*", "*/tmp/*" },
        },

        live_grep_args = function()
          local lga_actions = require("telescope-live-grep-args.actions")

          return {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = { -- extend mappings
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
          }
        end,

        undo = function()
          return {
            side_by_side = true,
            mappings = { -- this whole table is the default
              i = {
                -- IMPORTANT: Note that telescope-undo must be available when telescope is configured if
                -- you want to use the following actions. This means installing as a dependency of
                -- telescope in it's `requirements` and loading this extension from there instead of
                -- having the separate plugin definition as outlined above. See issue #6.
                ["<C-cr>"] = require("telescope-undo.actions").restore,
                ["<cr>"] = require("telescope-undo.actions").yank_additions,
                ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
              },
            },
          }
        end,
      }),
    })

  require("telescope")--[[@as Telescope]]
    .load_extension("notify")
end
