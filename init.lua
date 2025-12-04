-- init.lua (Обновленный под Lua Parser 3.0.0)

-- Инициализация менеджера плагинов Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", -- Убрана лишняя пробел в URL
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Настройки отображения и UI
vim.opt.guifont = "FiraMono_Nerd_Font:h16"
vim.opt.clipboard = "unnamedplus"
vim.opt.number = false        -- Отключены номера строк
vim.opt.termguicolors = true  -- Полноцветная поддержка
vim.opt.signcolumn = "yes:1"  -- Резервируется место для знаков (например, брейкпоинтов)

-- Увеличиваем таймауты для AI-запросов
vim.g.ollama_timeout = 30000
-- Кэширование запросов
vim.g.ollama_cache = true

-- Показывает иконки для разных типов сообщений
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local icons = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.INFO] = " ",
        [vim.diagnostic.severity.HINT] = "󰌶 ",
      }
      
      -- Функция для умного переноса текста
      local function wrap_text(text, width)
        if #text <= width then return {text} end
        
        local lines = {}
        while #text > 0 do
          local chunk = text:sub(1, width)
          local last_space = chunk:reverse():find(" ")
          
          if last_space and #text > width then
            chunk = text:sub(1, width - last_space)
            text = text:sub(width - last_space + 2)
          else
            text = text:sub(width + 1)
          end
          
          table.insert(lines, chunk)
        end
        
        return lines
      end
      
      local icon = icons[diagnostic.severity] or ""
      local wrapped_lines = wrap_text(diagnostic.message, 90)
      
      -- Возвращаем только первую строку с иконкой
      return icon .. wrapped_lines[1] .. (#wrapped_lines > 1 and "..." or "")
    end,
    spacing = 4,
    prefix = "",
    wrap_at = 90,
  },
  float = {
    border = "rounded",
    max_width = 90,
    wrap = true,
  },
  -- остальные настройки...
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})



-- Добавьте эти маппинги в вашу конфигурацию
vim.keymap.set('i', '<C-g>', function()
  require('ollama').generate()
end, { desc = "Generate code with Ollama" })

-- Проверка, запущен ли Neovim в Neovide
if vim.fn.exists("$NEOVIDE") == 1 then
  vim.opt.mouse = "a" -- Включаем мышь в Neovide
else
  vim.opt.mouse = "" -- Отключаем мышь в терминале
end

-- Настройки отступов
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = true

-- Настройка языковой раскладки для команд (транслитерация)
vim.opt.langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

-- Установка Leader клавиши
vim.g.mapleader = " "

-- Автокомманда для сворачивания многострочных строк в Rust (используя #""#)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    -- Устанавливаем метод сворачивания как "marker"
    vim.opt_local.foldmethod = "marker"
    -- Определяем маркеры для сворачивания строк в стиле Rust
    vim.opt_local.foldmarker = 'r",";' -- Используем одинарные кавычки для избежания экранирования
    -- Уровень сворачивания по умолчанию
    vim.opt_local.foldlevel = 0
  end
})

-- Автокомманда для распознавания файлов .tera как HTML
vim.api.nvim_create_autocmd({"BufNewFile","BufRead"}, {
  pattern = "*.tera",
  callback = function()
    vim.bo.filetype = "html"
  end
})

-- Подключение и применение маппингов из отдельного файла
local ok_mappings, mappings = pcall(require, "mappings")
if not ok_mappings then
  vim.api.nvim_err_writeln("Не удалось загрузить mappings: " .. mappings)
  mappings = {} -- Инициализируем пустую таблицу, если файл не найден
else
  for mode, mode_mappings in pairs(mappings) do
    for key, mapping in pairs(mode_mappings) do
      if type(mapping) == "table" and mapping[1] and mapping[2] then
        local rhs = mapping[1]
        local opts = mapping[2]
        vim.keymap.set(mode, key, rhs, opts)
      else
        vim.api.nvim_err_writeln("Ошибка в формате маппинга: mode=" .. mode .. ", key=" .. key)
        -- print("Ошибка в маппинге:", mode, key, vim.inspect(mapping)) -- Старый способ вывода ошибки
      end
    end
  end
end

-- Загрузка плагинов через Lazy.nvim
require("lazy").setup("plugins")
