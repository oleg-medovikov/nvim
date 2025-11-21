local M = {}

-- Функция для изменения размера шрифта
local guifontsize = 14
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
   ["<C-v>"] = {'<C-r>+', {noremap = true}},
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
  -- telescope
  ["<leader>ff"] = {
	function()
  require("telescope.builtin").find_files({
    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }, -- Учитывать .gitignore
  })
end, { desc = "Find files (respect .gitignore)" }
  },
["<leader>fg"] = {
  function()
    require("telescope.builtin").live_grep({
      -- Опционально: настройки для ripgrep
      additional_args = function(args)
        return vim.tbl_flatten({ args, "--hidden", "--glob", "!**/.git/*" })
      end,
    })
  end,
  { desc = "Search text in files (respect .gitignore)" }
},
  -- DAP
  ["<leader>db"] = { "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" } },

  -- Общие маппинги
  [";"] = { ":", { desc = "Enter command mode", nowait = true } },

  ["<Leader>t"] = {
    function()
        -- Поиск всех окон с терминальными буферами
        local terminals = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
                table.insert(terminals, win)
            end
        end

        if #terminals == 0 then
            -- Если терминал не открыт: создать новый (1/3 экрана)
            local width = math.floor(vim.o.columns / 3)
            vim.cmd("belowright vsplit | vertical resize " .. width .. " | terminal")
            vim.cmd("startinsert")
            vim.wo.winfixwidth = true -- Фиксируем ширину
        else
            -- Если терминал уже открыт: переключить размер
            local win = terminals[1]
            local current_width = vim.api.nvim_win_get_width(win)
            local columns = vim.o.columns
            local target_third = math.floor(columns / 3)
            local target_sixth = math.floor(columns / 6)

            -- Определяем новый размер
            local new_width = (current_width == target_third) and target_sixth or target_third

            -- Применяем изменения
            vim.api.nvim_win_set_width(win, new_width)

            -- Переключаемся на терминал только при расширении (1/3 экрана)
            if new_width == target_third then
                vim.api.nvim_set_current_win(win)
                vim.cmd("startinsert") -- Активируем режим вставки
            end
        end
    end,
    { desc = "Toggle terminal between 1/3 and 1/6 of screen", nowait = true }
}


}

M.i = {
  ["ii"] = { "<ESC>:w!<CR>", { desc = "Save and exit insert", nowait = true } },
  ["шш"] = { "<ESC>:w!<CR>", { desc = "Save and exit insert (Cyr)", nowait = true } },
  ["<C-v>"] = {'"+p', {noremap = true}},
}

M.v = {
  ["<Leader>y"] = {
    function()
      local selection = vim.fn.getreg('"')
      vim.fn.setreg('+', selection)
    end,
    { desc = "Copy to clipboard" }
  },
  ["<C-c>"] = {'"+y', {noremap = true}},
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
