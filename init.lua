local treesitter = require("vim.treesitter")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
function Iswindows()
	if package.config:sub(1, 1) == "\\" then
		return true
	else
		return false
	end
end
if Iswindows() then
	vim.o.shell = "pwsh.exe"
end
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
pythonPath = function()
	local cwd = vim.fn.getcwd()
	if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
		return cwd .. "/venv/bin/python"
	elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
		return cwd .. "/.venv/bin/python"
	elseif vim.fn.executable(cwd .. "\\venv\\Scripts\\python.exe") == 1 then
		return cwd .. "\\venv\\Scripts\\python.exe"
	elseif vim.fn.executable(cwd .. "\\.venv\\Scripts\\python.exe") == 1 then
		return cwd .. "\\.venv\\Scripts\\python.exe"
	else
		return vim.fn.exepath("python")
	end
end
vim.opt.rtp:prepend(lazypath)
function IsNotNeovide()
	if not vim.g.neovide then
		return true
	else
		return false
	end
end
if Iswindows() ~= true then
	vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
end
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.opt.termguicolors = true
vim.o.guifont = "CaskaydiaCove Nerd Font"
require("lazy").setup("plugins")
require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
})
--[[vim.api.nvim_create_autocmd("TermResponse", {
	once = true,
	callback = function()
		vim.cmd("q")
	end,
})
]]
--

require("ibl").setup()
mason = require("mason").setup()
require("mason-nvim-dap").setup()
require("mason-lspconfig").setup()
require("config.dapset")
require("dapui").setup()
Linters = {}
Mason_registry = require("mason-registry")
for _, pkg_info in ipairs(Mason_registry.get_installed_packages()) do
	for _, type in ipairs(pkg_info.spec.categories) do
		if type == "Linter" then
			Linters[#Linters + 1] = pkg_info.name
		end
	end
end
require("lint").linters_by_ft = { markdown = { Linters } }
nls = require("null-ls")
require("mason-null-ls").setup({
	automatic_installation = false,
	handlers = {
		mypy = function(source_name, methods)
			nls.register(nls.builtins.diagnostics.mypy.with({
				extra_args = function()
					return { "--python-executable", pythonPath() }
				end,
			}))
		end,
	},
})

require("null-ls").setup({
	sources = {
		-- Anything not supported by mason.
	},
})
require("lualine").setup({
	options = {
		theme = "auto",
	},
})
if not vim.g.neovide then
	require("neoscroll").setup({
		-- All these keys will be mapped to their corresponding default scrolling animation
		mappings = {
			"<C-u>",
			"<C-d>",
			"<C-b>",
			"<C-f>",
			"<C-y>",
			"<C-e>",
			"zt",
			"zz",
			"zb",
		},
		hide_cursor = true, -- Hide cursor while scrolling
		stop_eof = true, -- Stop at <EOF> when scrolling downwards
		respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
		cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
		easing_function = nil, -- Default easing function
		pre_hook = nil, -- Function to run before the scrolling animation starts
		post_hook = nil, -- Function to run after the scrolling animation ends
		performance_mode = false, -- Disable "Performance Mode" on all buffers.
	})
end
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
-- Setup language servers.
local lspconfig = require("lspconfig")
local lspservers = {}
local masonconfig = require("mason-lspconfig")
for _, pkg_info in ipairs(Mason_registry.get_installed_packages()) do
	for _, type in ipairs(pkg_info.spec.categories) do
		if type == "LSP" then
			lspservers[#lspservers + 1] = masonconfig.get_mappings().mason_to_lspconfig[pkg_info.name]
		end
	end
end
for _, lsp in ipairs(lspservers) do
	lspconfig[lsp].setup({ capabilities = capabilities })
end

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer

-- nvim cmp config

local cmp = require("cmp")
local lspkind = require("lspkind")
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.

			--require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		--completion = cmp.config.window.bordered(),
		--documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources(
		function()
			tab = {}
			tab.insert{{name ="nvim_lsp"}, {name = "luasnip"}, {name = "buffer"}, {name = "lazydev", group_index = 0}}
		--{ name = "vsnip" }, -- For vsnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		--{ name = 'snippy' }, -- For snippy users.
			--- Check if lazydev is loaded
		end

		),
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text",
			maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			-- can also be a function to dynamically calculate max width such as
			-- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
			show_labelDetails = true, -- show labelDetails in menu. Disabled by default

			-- The function below will be called before any actual modifications from lspkind
			-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
			before = function(entry, vim_item)
				return vim_item
			end,
		}),
	},
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, { { name = "buffer" } }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = { { name = "buffer" } },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.

-- linter autocommand
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		-- Formatter configurations for filetype "lua" go here
		-- and will be executed in order
		lua = {
			-- "formatter.filetypes.lua" defines default configurations for the
			-- "lua" filetype
			require("formatter.filetypes.lua").stylua,

			-- You can also define your own configuration
			function()
				-- Supports conditional formatting
				if util.get_current_buffer_file_name() == "special.lua" then
					return nil
				end

				-- Full specification of configurations is down below and in Vim help
				-- files
				return {
					exe = "stylua",
					args = {
						"--search-parent-directories",
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
						"--",
						"-",
					},
					stdin = true,
				}
			end,
		},

		-- Use the special "*" filetype for defining formatter configurations on
		-- any filetype
		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
require("telescope").load_extension("zoxide")
if vim.g.neovide then
	vim.g.neovide_theme = "auto"
	vim.g.neovide_no_idle = true
end
require("nvim-lightbulb").setup({
	autocmd = { enabled = true },
	ignore = {
		clients = { "ruff_lsp" },
	},
})
require("config.keybinds")
