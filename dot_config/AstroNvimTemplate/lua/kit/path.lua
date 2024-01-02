---@class AndromedaPathKit
local M = {}

M.INIT_EXT = "init"
M.CONFIG_PATH = Globals.vim_path .. "/lua/"

-- >>>>>>>>>>>>>>>>>> Helpers <<<<<<<<<<<<<<<<<<<< --

---@param path string
function M.is_dir(path) return M.file_exist(path .. "/") end

---@param file string
function M.file_exist(file)
  -- some error codes:
  -- 13 : EACCES - Permission denied
  -- 17 : EEXIST - File exists
  -- 20	: ENOTDIR - Not a directory
  -- 21	: EISDIR - Is a directory
  --
  local isok, errstr, errcode = os.rename(file, file)
  if isok == nil then
    if errcode == 13 then
      -- Permission denied, but it exists
      return true
    end
    return false
  end
  return true
end

---@param path string
---@return string
function M.get_filename(path, with_extension)
  with_extension = with_extension or false
  if type(path) ~= "string" then return "" end
  local filename = path:match("^.+/(.+)$")
  return with_extension and filename or filename:gsub("%..+$", "")
end

---@param path string
---@param filter? function
---@return string[]
function M.get_files(path, filter)
  local files = vim.split(vim.fn.glob(path), "\n", { trimempty = true })
  if filter then files = table.filter(files, filter) end
  return files
end

---@param dir string
---@return string[]
function M.get_lua_files(dir) return M.get_files(M.CONFIG_PATH .. dir .. "/*.lua") end

---@class LoadDirOpts
---@field filter? function
---@field load_fn? function
---@field skip_directories? boolean

---@type LoadDirOpts
local DEFAULT_LOAD_OPTS = {
  filter = nil,
  load_fn = require,
  skip_directories = false,
}

---@param dir string
---@param opts? LoadDirOpts
function M.load_dir(dir, opts)
  ---@type LoadDirOpts
  opts = table.extend(opts, DEFAULT_LOAD_OPTS)

  local filepath = Globals.lua_dir .. "/" .. dir .. "/*"
  local files = M.get_files(filepath, opts.filter)

  table.sort(files, function(a, b)
    local a_name = a:match("^.+/(.+)$"):gsub("%..+$", "")
    local b_name = b:match("^.+/(.+)$"):gsub("%..+$", "")

    if a_name == M.INIT_EXT then
      return true
    elseif b_name == M.INIT_EXT then
      return false
    else
      return a_name < b_name
    end
  end)

  for _, file in ipairs(files) do
    local filename = M.get_filename(file)
    require(file:gsub(M.CONFIG_PATH, ""):gsub(".lua", ""))

    if M.is_dir(file) then
      if not opts.skip_directories then M.load_dir(dir .. "/" .. filename, opts) end
    else
      opts.load_fn(dir:gsub(Globals.path_sep, "."):concat(".", filename))
    end
  end
end

return M
