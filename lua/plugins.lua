return {
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

  -- Ollama
  {
    "nomnivore/ollama.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      require("ollama").setup({
        model = "deepseek-r1:14b",
        url = "http://192.168.0.76:11434",
        system_prompt = "Отвечай на русском языке"
      })
      vim.keymap.set("n", "<leader>oq", ":Ollama ", { desc = "Ollama Query" })
      vim.keymap.set("v", "<leader>or", ":Ollama ", { desc = "Ollama Request" })
    end
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
