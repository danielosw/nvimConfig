local mason = require("mason").setup()
require("mason-nvim-dap").setup()
require("mason-lspconfig").setup()
local Linters = {}
local Formatters = {}
local lspconfig = require("lspconfig")
local lspservers = {}
local masonconfig = require("mason-lspconfig")
Mason_registry = require("mason-registry")
local navic = require("nvim-navic")
local navbud = require("nvim-navbuddy")

local on_attach = function(client, bufnr)
	-- navic
	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
		navbud.attach(client, bufnr)
	end
end
Daps = {}
-- loop through packages.
for _, pkg_info in ipairs(Mason_registry.get_installed_packages()) do
	-- Loop through the type assigned to the package.
	for _, type in ipairs(pkg_info.spec.categories) do
		-- Do things based on type.
		if type == "DAP" then
			Daps[#Daps+1] = pkg_info.name
		elseif type == "LSP" then
			lsp = masonconfig.get_mappings().mason_to_lspconfig[pkg_info.name]
			if lsp ~= "pylsp" then
				lspconfig[lsp].setup({ on_attach = on_attach })
			else
				lspconfig[lsp].setup({
					on_attach = function(client, bufnr)
						navic.attach(client, bufnr)
					end,
					settings = {
						["pylsp"] = {
							plugins = {
								autopep8 = {
									enabled = false,
								},
								mccabe = {
									enabled = false,
								},
								pycodestyle = {
									enabled = false,
								},
								pyflakes = {
									enabled = false,
								},
								yapf = {
									enabled = false,
								},
							},
						},
					},
				})
			end
		end
	end
end

-- setup gdscript lsp
require("lspconfig").gdscript.setup({})
-- setup fish-lsp
require("lspconfig").fish_lsp.setup({})
-- setup ruff
ruffconfig = function()
	if Windows then
		return vim.env.HOME .. "\\AppData\\Roaming\\ruff\\ruff.toml"
	else
		return vim.env.HOME .. "/.config/ruff/ruff.toml"
	end
end
	require("lspconfig").ruff.setup({
		init_options = {
			settings = {
				configurationPreference = "filesystemFirst",
				configuration = ruffconfig(),
			},
		},
	})
-- Define navic winbar.
vim.o.winbar = "%{%v:lua.require('nvim-navic').get_location()%}"
local nls = require("null-ls")
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
						PythonPath,
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
