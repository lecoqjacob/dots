local Kit = require("kit")

---@class AndromedaToggleKit
local M = {}

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.option(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      ---@diagnostic disable-next-line: no-unknown
      vim.opt_local[option] = values[2]
    else
      ---@diagnostic disable-next-line: no-unknown
      vim.opt_local[option] = values[1]
    end
    return Kit.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
  end

  ---@diagnostic disable-next-line: no-unknown
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      Kit.info("Enabled " .. option, { title = "Option" })
    else
      Kit.warn("Disabled " .. option, { title = "Option" })
    end
  end
end

function M.colorizer(buffer)
  local c = require("colorizer")

  buffer = buffer or 0
  local enabled = c.is_buffer_attached(0)

  if enabled then
    c.detach_from_buffer(0)
    Kit.info("Enabled color highlighting", { title = "Colorizer" })
  else
    c.attach_to_buffer(0)
    Kit.warn("Disabled color highlighting", { title = "Colorizer" })
  end
end

return M
