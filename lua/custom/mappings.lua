---@type MappingsTable
local M = {}

M.general = {
  i = {
    ["ii"] = {"<ESC>:w<ENTER>", opts = { nowait = true } },
  },
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
}

-- more keybinds!

return M
