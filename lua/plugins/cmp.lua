return {
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",
	"saadparwaiz1/cmp_luasnip",
	"onsails/lspkind.nvim",

	{
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
		build = function()
			if Windows then
				return
			else
				return "make install_jsregexp"
			end
		end,
		dependencies = { "rafamadriz/friendly-snippets", "molleweide/LuaSnip-snippets.nvim" },
	},
}
