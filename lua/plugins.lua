return {
  {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require("dbee").install()
  end,
  config = function()
    require("dbee").setup(--[[optional config]])
  end,
  },
  -- NERDTree
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "nvimtree"
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },

-- Rust tools
{
  "simrat39/rust-tools.nvim",
  dependencies = { "neovim/nvim-lspconfig" },
  ft = "rust", -- Загружать только для Rust-файлов
  config = function()
    local rt = require("rust-tools")
    rt.setup({
      server = {
	on_attach = function(client, bufnr)
	  -- Keymaps для Rust
	  vim.keymap.set("n", "<leader>rr", rt.runnables.runnables, { buffer = bufnr, desc = "Rust Runnables" })
	  -- Используем встроенное форматирование LSP
	  vim.keymap.set("n", "<leader>rf", vim.lsp.buf.format, { buffer = bufnr, desc = "Rust Format" })
	end
      }
    })
  end
},
  -- Mason (установка LSP)
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "rust_analyzer", "lua_ls" } -- Автоустановка LSP
      })
    end
  },

  -- Tree-sitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "rust", "lua", "python" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true }
      })
    end
  },

-- colorscheme
{
   "folke/tokyonight.nvim",
   config = function()
      vim.cmd[[colorscheme tokyonight]]
   end
},


-- Ollama

-- Custom Parameters (with defaults)
{
 "David-Kunz/gen.nvim",
 opts = {
     model = "codellama:13b", -- The default model to use.
     quit_map = "q", -- set keymap to close the response window
     retry_map = "<c-r>", -- set keymap to re-send the current prompt
     accept_map = "<c-cr>", -- set keymap to replace the previous selection with the last result
     host = "192.168.0.76", -- The host running the Ollama service.
     port = "11434", -- The port on which the Ollama service is listening.
     display_mode = "horizontal-split", -- The display mode. Can be "float" or "split" or "horizontal-split".
     show_prompt = false, -- Shows the prompt submitted to Ollama. Can be true (3 lines) or "full".
     show_model = false, -- Displays which model you are using at the beginning of your chat session.
     no_auto_close = false, -- Never closes the window automatically.
     file = false, -- Write the payload to a temporary file to keep the command short.
     hidden = false, -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
     init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
     -- Function to initialize Ollama
     command = function(options)
         local body = {model = options.model, stream = true}
         return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
     end,
     -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
     -- This can also be a command string.
     -- The executed command must return a JSON object with { response, context }
     -- (context property is optional).
     -- list_models = '<omitted lua function>', -- Retrieves a list of model names
     result_filetype = "markdown", -- Configure filetype of the result buffer
     debug = false -- Prints errors and the command which is run.
 }
},
-- Dev icons
  {
    "nvim-tree/nvim-web-devicons",
    config = true
  },
{
  'andrew-george/telescope-themes', -- Правильное имя репозитория
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    require('telescope').load_extension('themes')
  end
},
{
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Обязательно :cite[4]
    "nvim-treesitter/nvim-treesitter",
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    -- Удалите строки с load_extension("terms") 
  end
}
}
