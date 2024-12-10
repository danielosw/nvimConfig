return {
	{
		"zaldih/themery.nvim",
		config = function()
			-- This is some of this the oldest code that's still around, and as such its kind of a mess
			local themes = {}
			for _, value in pairs(vim.fn.getcompletion("", "color")) do
				themes[#themes + 1] = {
					name = value,
					colorscheme = value,
				}
			end

			require("themery").setup({
				themes = themes,
				livePreview = true,
			})
		end,
		priority = 100,
	},

	{ "catppuccin/nvim", name = "catppuccin", priority = 200 },
	{ "folke/tokyonight.nvim", priority = 200 },
	{ "EdenEast/nightfox.nvim", priority = 200 },
	{
		"Mofiqul/dracula.nvim",
		priority = 200,
		opts = {
			show_end_of_buffer = false,
			transparent_bg = false,
			italic_comment = false,
			colors = {},
			overrides = {
				WinBar = { bg = "bg" },
				WinBarNC = { bg = "bg" },
				TabLineSel = { bg = "bg" },
			},
		},
	},
}
