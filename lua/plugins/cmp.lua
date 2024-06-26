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
		-- check if luarocks is installed
		 if vim.fn.exepath("luarocks") ~= "" then
				-- install or update jsregexp locally
				vim.cmd("te luarocks --local install jsregexp")
			end
			end,
		dependencies = { "rafamadriz/friendly-snippets", "molleweide/LuaSnip-snippets.nvim" },
	},
}
