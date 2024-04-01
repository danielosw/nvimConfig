return {
	"neovim/nvim-lspconfig",
	"nvimtools/none-ls.nvim",
	"jay-babu/mason-null-ls.nvim",
	"williamboman/mason-lspconfig.nvim",
	"kosayoda/nvim-lightbulb",
	{
		"aznhe21/actions-preview.nvim",
		config = function()
			vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
		end,
	},

}
