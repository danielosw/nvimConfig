return {
	"neovim/nvim-lspconfig",
	"nvimtools/none-ls.nvim",
	"jay-babu/mason-null-ls.nvim",
	"williamboman/mason-lspconfig.nvim",
	{
		"danielosw/nvim-lightbulb",
		opts = {
			autocmd = { enabled = true },
			ignore = {
				-- Annoyingly this causes dotfyle to thing we have ruff explcitly installed when we don't
				clients = { "ruff" },
			},
		},
	},
	{
		"aznhe21/actions-preview.nvim",
		config = function()
			vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
		end,
	},
}
