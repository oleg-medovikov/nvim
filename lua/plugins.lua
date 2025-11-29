local colors = {
  blue   = '#80a0ff',
  cyan   = '#79dac8',
  black  = '#080808',
  white  = '#c6c6c6',
  red    = '#ff5189',
  violet = '#d183e8',
  grey   = '#303030',
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.white },
  },
}

return {
  -- Mason ДОЛЖЕН быть первым
{
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  config = function()
    require("mason").setup()
    
    -- Ручная настройка LSP после установки Mason
    vim.api.nvim_create_user_command("MasonLspSetup", function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      if cmp_ok then
        capabilities = cmp_nvim_lsp.default_capabilities()
      end

      -- Rust Analyzer
      vim.lsp.start({
        name = "rust_analyzer",
        cmd = { "rust-analyzer" },
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
          }
        }
      })

      -- Lua LS
      vim.lsp.start({
        name = "lua_ls",
        cmd = { "lua-language-server" },
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }
            }
          }
        }
      })
    end, {})
  end
},




   -- nvim-cmp с интеграцией Ollama для Qwen2-Coder 30B
{
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer", 
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "nomnivore/ollama.nvim",  -- Добавляем плагин для Ollama
  },
  config = function()
    local cmp = require('cmp')
    
    -- Настройка Ollama
    require('ollama').setup({
      model = "deepseek-r1:8b",  -- Укажите точное название модели
      url = "https://vacuously-executive-plaice.cloudpub.ru",
      -- Дополнительные настройки для улучшения качества
      context_lines = 15,  -- Больше контекста для лучших предложений
      num_predict = 128,   -- Длина предсказания
      temperature = 0.2,   -- Меньше креативности, больше точности
    })

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ 
          select = true,
          behavior = cmp.ConfirmBehavior.Replace,
        }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'ollama', priority = 1000 },  -- AI-дополнения с высоким приоритетом
        { name = 'nvim_lsp', priority = 750 }, -- LSP дополнения
        { name = 'luasnip', priority = 500 },  -- Сниппеты
        { name = 'buffer', priority = 250 },   -- Текст из буфера
        { name = 'path', priority = 200 },     -- Пути к файлам
      }),
      
      -- Оптимизации для AI-дополнений
      performance = {
        debounce = 300,  -- Увеличиваем debounce для AI-запросов
        throttle = 500,
        async_budget = 1000,
      },
      
      -- Настройка внешнего вида для AI-предложений
      formatting = {
        format = function(entry, vim_item)
          -- Добавляем иконку для AI-предложений
          if entry.source.name == "ollama" then
            vim_item.kind = "🤖 " .. vim_item.kind
          end
          return vim_item
        end,
      },
    })

    -- Дополнительная настройка для командной строки
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
  end,
},


  -- Nvim-tree с простой конфигурацией
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
      })
    end,
  },

  -- Tree-sitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "rust", "lua", "python", "sql", "javascript", "html", "css" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = true,
      })
      vim.cmd[[colorscheme tokyonight]]
    end
  },

  -- Lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = bubbles_theme,
          component_separators = '',
          section_separators = { left = ' ', right = ' ' },
          disabled_filetypes = {
            "NvimTree",
            "toggleterm"
          }
        },
        sections = {
          lualine_a = { { 'mode', separator = { left = ' ' }, right_padding = 2 } },
          lualine_b = { 'filename', 'branch' },
          lualine_c = { '%=' },
          lualine_x = {},
          lualine_y = { 'filetype', 'progress' },
          lualine_z = {
            { 'location', separator = { right = ' ' }, left_padding = 2 },
          },
        },
        inactive_sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'location' },
        },
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("telescope").setup({})
    end
  },
 {
   "supermaven-inc/supermaven-nvim",
   config = function()
     require("supermaven-nvim").setup({})
   end,
 },

}
