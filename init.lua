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

-- Базовые настройки Neovim
vim.opt.number = true        -- Номера строк
vim.opt.mouse = ""          -- Поддержка мыши
vim.opt.termguicolors = true -- Полноцветная поддержка
vim.g.mapleader = " "  -- Пробел как leader


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


