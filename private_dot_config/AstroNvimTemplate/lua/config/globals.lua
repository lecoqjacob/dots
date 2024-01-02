Globals = {}

local os_name = vim.loop.os_uname().sysname
local home = Globals.is_windows and os.getenv("USERPROFILE") or os.getenv("HOME")

Globals.home = home
Globals.is_mac = os_name == "Darwin"
Globals.is_linux = os_name == "Linux"
Globals.is_wsl = vim.fn.has("wsl") == 1
Globals.is_windows = os_name:find("Windows")

Globals.vim_path = vim.fn.stdpath("config")
Globals.path_sep = Globals.is_windows and "\\" or "/"
Globals.lua_dir = Globals.vim_path .. Globals.path_sep .. "lua"
Globals.modules_dir = Globals.vim_path .. Globals.path_sep .. "modules"
Globals.data_dir = string.format("%s/site/", vim.fn.stdpath("data"))
Globals.cache_dir = home .. Globals.path_sep .. ".cache" .. Globals.path_sep .. "nvim" .. Globals.path_sep

--! >>>>>>>>> Functions <<<<<<<<<<< --

NOOP = function() end

--* Debugging
Debug = function(...)
  local str = ""
  local args = { ... }

  for i, v in ipairs(args) do
    str = str .. vim.inspect(v)
    if i ~= #args then str = str .. ", " end
  end

  Echo({ { str, "Normal" } }, false, true)
end

---@param chunks any[]
---@param history? boolean
---@param key_return? boolean
Echo = function(chunks, history, key_return)
  history = history or false
  key_return = key_return or false

  vim.cmd("redraw")
  vim.api.nvim_echo(chunks, history, {})
  if key_return then vim.fn.getchar() end
end
