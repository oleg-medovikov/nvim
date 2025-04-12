-- Инициализация менеджера плагинов Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.guifont = "FiraMono_Nerd_Font:h16"
vim.opt.clipboard = "unnamedplus"

-- Базовые настройки Neovim
vim.opt.number = false        -- Номера строк
-- Проверка, запущен ли Neovim в Neovide
if vim.fn.exists("$NEOVIDE") == 1 then
  vim.opt.mouse = "a" -- Включаем мышь в Neovide
else
  vim.opt.mouse = "" -- Отключаем мышь в терминале
end
vim.opt.termguicolors = true -- Полноцветная поддержка
vim.g.mapleader = " "  -- Пробел как leader
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = true
vim.opt.signcolumn = "yes:1"

-- сворачивание #""#
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    -- Устанавливаем метод сворачивания как "marker"
    vim.opt_local.foldmethod = "marker"

    -- Определяем маркеры для сворачивания
    vim.opt_local.foldmarker = [[r#","#]]

    -- Уровень сворачивания по умолчанию
    vim.opt_local.foldlevel = 0
  end
})


-- Подключение mappings.lua
local mappings = require("mappings")

-- Применение маппингов
for mode, mode_mappings in pairs(mappings) do
  for key, mapping in pairs(mode_mappings) do
    if type(mapping) == "table" and mapping[1] and mapping[2] then
      vim.keymap.set(mode, key, mapping[1], mapping[2])
    else
      print("Ошибка в маппинге:", mode, key, vim.inspect(mapping))
    end
  end
end

-- Загрузка плагинов из файла plugins.lua
require("lazy").setup("plugins")
