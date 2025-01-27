local M = {}

-- Функция для изменения размера шрифта
local guifontsize = 20
local guifont = "FiraMono Nerd Font"

local function adjust_font_size(amount)
  guifontsize = guifontsize + amount
  if guifontsize < 1 then
    guifontsize = 1
  elseif guifontsize > 100 then
    guifontsize = 100
  end
  vim.opt.guifont = string.format("%s:h%d", guifont, guifontsize)
  vim.defer_fn(function()
    vim.notify(string.format("Font size changed to: %s %d", guifont, guifontsize), vim.log.levels.INFO)
  end, 100)
end

-- Режимы должны быть на верхнем уровне
M.n = {
  -- Сочетания клавиш для изменения размера шрифта
  ["<C-=>"] = {
    function() adjust_font_size(1) end,
    { desc = "Increase font size" }
  },
  ["<C-->"] = {
    function() adjust_font_size(-1) end,
    { desc = "Decrease font size" }
  },
  -- nerdtree
  ["<C-n>"] = {"<cmd>NvimTreeToggle<CR>", {nowait = true} },

  -- DAP
  ["<leader>db"] = { "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" } },

  -- Общие маппинги
  [";"] = { ":", { desc = "Enter command mode", nowait = true } },
  ["<Leader>t"] = {
    function()
      local width = math.floor(vim.o.columns / 3)
      vim.cmd("belowright vsplit | vertical resize " .. width .. " | terminal")
      vim.cmd("startinsert")
    end,
    { desc = "Open terminal in right third", nowait = true }
  }
}

M.i = {
  ["ii"] = { "<ESC>:w<CR>", { desc = "Save and exit insert", nowait = true } },
  ["шш"] = { "<ESC>:w<CR>", { desc = "Save and exit insert (Cyr)", nowait = true } }
}

M.v = {
  ["<Leader>y"] = {
    function()
      local selection = vim.fn.getreg('"')
      vim.fn.setreg('+', selection)
    end,
    { desc = "Copy to clipboard" }
  }
}

M.t = {
  ["<ESC>"] = { "<C-\\><C-n><C-w>h", { desc = "Exit terminal mode", noremap = true } }
}

-- Автоматическая команда (не является маппингом)
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.wrap = false
  end
})

return M
