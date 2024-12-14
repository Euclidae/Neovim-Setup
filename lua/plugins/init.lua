return {
  -- Git integration with lazy.git   
  {
        "kdheepak/lazygit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- Optional: Add keybindings
        keys = {
            { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
        },
    },

    -- Formatting
    {
        "stevearc/conform.nvim",
        event = 'BufWritePre', -- Enable format on save
        opts = require "configs.conform",
    },

    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",        -- C/C++
                    "pyright",       -- Python
                    "rust_analyzer", -- Rust
                },
                automatic_installation = true,
            })

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- C/C++ setup
            lspconfig.clangd.setup({
                capabilities = capabilities,
            })

            -- Python setup
            lspconfig.pyright.setup({
                capabilities = capabilities,
            })

            -- Rust setup is handled by rustaceanvim
        end,
    },
    -- C++-specific plugins
    {
        "p00f/clangd_extensions.nvim",
        ft = { "c", "cpp" },
        config = function()
            require("clangd_extensions").setup {
                server = {
                    on_attach = function(client, bufnr)
                        -- Enable inlay hints for C++
                        require("clangd_extensions.inlay_hints").setup_autocmd()
                        require("clangd_extensions.inlay_hints").set_inlay_hints()
                    end,
                    capabilities = require("cmp_nvim_lsp").default_capabilities(),
                },
                extensions = {
                    -- Automatically set inlay hints
                    autoSetHints = true,
                    -- These apply to the default ClangdSetInlayHints command
                    inlay_hints = {
                        inline = false,
                        -- Only show inlay hints for the current line
                        only_current_line = false,
                        -- Event which triggers a refersh of the inlay hints.
                        -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
                        -- not that this may cause higher CPU usage.
                        -- This option is only respected when only_current_line and
                        -- autoSetHints both are true.
                        only_current_line_autocmd = "CursorHold",
                        -- whether to show parameter hints with the inlay hints or not
                        show_parameter_hints = true,
                        -- whether to show variable name before type hints with the inlay hints or not
                        show_variable_name = false,
                        -- prefix for parameter hints
                        parameter_hints_prefix = "<- ",
                        -- prefix for all the other hints (type, chaining)
                        other_hints_prefix = "=> ",
                    },
                }
            }
        end
    },
    {
        "Civitasv/cmake-tools.nvim",
        ft = { "c", "cpp" },
        config = function()
            require("cmake-tools").setup {
                cmake_command = "cmake",
                cmake_build_directory = "build",
                cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
                cmake_build_options = {},
                cmake_console_size = 10,       -- cmake output window height
                cmake_show_console = "always", -- "always", "only_on_error"
                cmake_dap_configuration = { name = "cpp", type = "codelldb", request = "launch" },
                cmake_dap_open_command = require("dap").repl.open,
            }
        end
    },

    -- Rust-specific plugins
    {
        'mrcjkb/rustaceanvim',
        version = '3e37999d606a2653d8f9096e5c5197aa0b47d5f7', -- Use a specific commit
        ft = "rust",
        config = function()
            local mason_registry = require('mason-registry')
            local codelldb = mason_registry.get_package("codelldb")
            local extension_path = codelldb:get_install_path() .. "/extension/"
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
            local cfg = require('rustaceanvim.config')

            vim.g.rustaceanvim = {
                dap = {
                    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                },
                server = {
                    on_attach = function(client, bufnr)
                        -- Enable inlay hints
                        vim.lsp.inlay_hint(bufnr, true)
                    end,
                },
            }
        end
    },
    {
        'rust-lang/rust.vim',
        ft = "rust",
        init = function()
            vim.g.rustfmt_autosave = 1
        end
    },
    {
        'saecki/crates.nvim',
        ft = { "rust", "toml" },
        config = function()
            require("crates").setup({
                popup = {
                    autofocus = true,
                },
            })
        end,
    },

    -- Debugging
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "mfussenegger/nvim-dap-python",
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.before.attach.dapui_config = function() dapui.open() end
            dap.listeners.before.launch.dapui_config = function() dapui.open() end
            dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
            dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

            -- Python debugger setup
            require('dap-python').setup('python')

            -- C/C++ debugger setup (using codelldb)
            dap.adapters.codelldb = {
                type = 'server',
                port = "${port}",
                executable = {
                    command = vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/adapter/codelldb',
                    args = { "--port", "${port}" },
                }
            }
            dap.configurations.cpp = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                }
            }
            dap.configurations.c = dap.configurations.cpp
        end,
    },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            require("dapui").setup()
        end,
    },

    -- Syntax highlighting and code analysis
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "cpp", "python", "rust", "lua", "vim" },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                }),
            })
        end,
    },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup()
        end,
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup()
        end,
    },

    -- Git integration
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup()
        end,
    },

 {
        "kdheepak/lazygit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- Optional: Add keybindings
        keys = {
            { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
        },
    },
} 
