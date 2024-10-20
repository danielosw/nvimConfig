mason = require("mason").setup()
require("mason-nvim-dap").setup()
require("mason-lspconfig").setup()
Linters = {}
Formatters = {}
local lspconfig = require("lspconfig")
local lspservers = {}
local masonconfig = require("mason-lspconfig")
Mason_registry = require("mason-registry")
local navic = require("nvim-navic")
local navbud = require("nvim-navbuddy")
local conform = require("conform")
local on_attach = function(client, bufnr)
	-- navic
	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
		navbud.attach(client, bufnr)
	end
end
-- loop through packages.
for _, pkg_info in ipairs(Mason_registry.get_installed_packages()) do
	-- Loop through the type assigned to the package.
	for _, type in ipairs(pkg_info.spec.categories) do
		-- Do things based on type.
		if type == "Linter" then
			Linters[#Linters + 1] = pkg_info.name
		elseif type == "Formatter" then
			Formatters[#Linters + 1] = pkg_info.name
		elseif type == "LSP" then
			lsp = masonconfig.get_mappings().mason_to_lspconfig[pkg_info.name]
			lspconfig[lsp].setup({ on_attach = on_attach })
		end
	end
end
haveformat = function(bufnr, formatter)
	if conform.get_formatter_info(formatter, bufnr).available then
			return { formatter }
	else
		return { lsp_format = "fallback" }
	end
end
conform.setup({
	formatters_by_ft = {
		lua = function(bufnr)
			if conform.get_formatter_info("stylua", bufnr).available then
				return { "stylua" }
			else
				return { lsp_format = "fallback" }
			end
		end,
		rust = function(bufnr)
			if conform.get_formatter_info("rustftm", bufnr).available then
				return { "rustftm" }
			else
				return { lsp_format = "fallback" }
			end
		end,

		python = function(bufnr)
			if require("conform").get_formatter_info("ruff_format", bufnr).available then
				return { "ruff_format" }
			else
				return { "isort" }
			end
		end,
		typescript = function(bufnr)
			return haveformat(bufnr, "biome-check")
		end,
		javascript = function(bufnr)
			return haveformat(bufnr, "biome-check")
		end,
		html = function(bufnr)
			return haveformat(bufnr, "biome-check")
		end,
		css = function(bufnr)
			return haveformat(bufnr, "biome-check")
		end,
		c = function(bufnr)
		    return haveformat(bufnr, "clang-format")
		end,
		cpp = function(bufnr)
		    return haveformat(bufnr, "clang-format")
		end,
	},
	["*"] = { "codespell" },
})

-- setup gdscript lsp
if vim.fn.exepath("godot") ~= "" then
	require("lspconfig").gdscript.setup({})
end
-- setup fish-lsp
if vim.fn.exepath("fish-lsp") ~= "" then
	require("lspconfig").fish_lsp.setup({})
end
-- Define navic winbar.
vim.o.winbar = "%{%v:lua.require('nvim-navic').get_location()%}"
nls = require("null-ls")
function getvenv()
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
-- Setup none-ls
require("mason-null-ls").setup({
	automatic_installation = false,
	handlers = {
		-- Change mypy to reference a venv.
		mypy = function(source_name, methods)
			nls.register(nls.builtins.diagnostics.mypy.with({
				extra_args = function()
					return {
						"--python-executable",
						getvenv(),
					}
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
