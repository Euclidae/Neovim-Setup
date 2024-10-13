require "nvchad.mappings"

local map = vim.keymap.set

-- General mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- LSP mappings
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
map("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

-- Debugging mappings
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Continue" })
map("n", "<Leader>di", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Step into" })
map("n", "<Leader>do", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Step over" })
map("n", "<Leader>dO", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Step out" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", { desc = "Open REPL" })
map("n", "<Leader>dl", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Run last" })
map("n", "<Leader>du", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Toggle DAP UI" })
map("n", "<Leader>dt", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Terminate" })

-- File explorer (nvim-tree) mappings
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Fuzzy finder (Telescope) mappings
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })

-- Rust-specific mappings
map("n", "<leader>rr", "<cmd>RustRun<CR>", { desc = "Rust run" })
map("n", "<leader>rt", "<cmd>RustTest<CR>", { desc = "Rust test" })
map("n", "<leader>rb", "<cmd>Cargo build<CR>", { desc = "Cargo build" })
map("n", "<leader>rc", "<cmd>Cargo check<CR>", { desc = "Cargo check" })

-- crates.nvim mappings
map("n", "<leader>ct", require('crates').toggle, { desc = "Toggle crates popup" })
map("n", "<leader>cr", require('crates').reload, { desc = "Reload crates" })
map("n", "<leader>cv", require('crates').show_versions_popup, { desc = "Show crate versions" })
map("n", "<leader>cf", require('crates').show_features_popup, { desc = "Show crate features" })
map("n", "<leader>cd", require('crates').show_dependencies_popup, { desc = "Show crate dependencies" })


-- C++-specific mappings
map("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<CR>", { desc = "Switch between source/header" })
map("n", "<leader>cs", "<cmd>ClangdSymbolInfo<CR>", { desc = "Show symbol info" })
map("n", "<leader>ct", "<cmd>ClangdTypeHierarchy<CR>", { desc = "Show type hierarchy" })
map("n", "<leader>cm", "<cmd>ClangdMemoryUsage<CR>", { desc = "Show memory usage" })

-- CMake mappings
map("n", "<leader>cg", "<cmd>CMakeGenerate<CR>", { desc = "CMake Generate" })
map("n", "<leader>cb", "<cmd>CMakeBuild<CR>", { desc = "CMake Build" })
map("n", "<leader>cr", "<cmd>CMakeRun<CR>", { desc = "CMake Run" })
map("n", "<leader>cd", "<cmd>CMakeDebug<CR>", { desc = "CMake Debug" })
map("n", "<leader>cc", "<cmd>CMakeClean<CR>", { desc = "CMake Clean" })
map("n", "<leader>cx", "<cmd>CMakeClose<CR>", { desc = "CMake Close" })
