-- ~/.config/nvim/lua/ollama-test.lua
local ollama = require('ollama')

-- Проверка доступности сервера
vim.api.nvim_create_user_command('OllamaTest', function()
  local response = ollama.prompt("print hello world in python")
  print("Ollama response:", response)
end, {})
