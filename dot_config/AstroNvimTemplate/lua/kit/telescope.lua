local Kit = require("kit")

---@class Telescope
---@field setup fun(opts: table)
---@field builtin table<string,any>
---@field extensions table<string, any>
---@field load_extension fun(extension: string)

---@class AndromedaTelescopeKitOpts
---@field cwd? string|boolean
---@field show_untracked? boolean

---@class AndromedaTelescopeKit
---@overload fun(builtin:string, opts?:AndromedaTelescopeKitOpts)
local M = setmetatable({}, {
  __call = function(m, ...) return m.telescope(...) end,
})

---@param extension string
function M.load_telescope_plugin(extension)
  ---@diagnostic disable-next-line: redundant-parameter
  require("astrocore").on_load("telescope.nvim", function()
    require("telescope")--[[@as Telescope]]
      .load_extension(extension)
  end)
end

M.available_extensions = {
  { "debugloop/telescope-undo.nvim", extension = "undo" },
  { "jvgrootveld/telescope-zoxide", extension = "zoxide" },
  { "nvim-telescope/telescope-frecency.nvim", extension = "frecency" },
  { "nvim-telescope/telescope-live-grep-args.nvim", extension = "live_grep_args" },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    enabled = vim.fn.executable("make") == 1,
    build = "make",
    extension = "fzf",
  },
}

----------------
-- Config Files
----------------
function M.config_files() return Kit.telescope("find_files", { cwd = vim.fn.stdpath("config") }) end

-- this will return a function that calls telescope.
---@param builtin string
---@param opts? AndromedaTelescopeKitOpts
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }

  return function()
    builtin = params.builtin

    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = Kit.root() }, opts or {}) --[[@as AndromedaTelescopeKitOpts]]

    ---------
    -- FILES
    ---------
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end

    ---------
    -- CWD
    ---------
    if opts.cwd and opts.cwd ~= vim.loop.cwd() then
      ---@diagnostic disable-next-line: inject-field
      opts.attach_mappings = function(_, map)
        map("i", "<a-c>", function()
          local action_state = require("telescope.actions.state")
          local line = action_state.get_current_line()
          M.telescope(
            params.builtin,
            vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line })
          )()
        end)
        return true
      end
    end

    require("telescope.builtin")[builtin](opts)
  end
end

return M
