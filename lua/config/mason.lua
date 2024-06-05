mason = require("mason").setup()
require("mason-nvim-dap").setup()
require("mason-lspconfig").setup()
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


