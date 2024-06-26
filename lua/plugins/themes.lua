return {
	{
		"zaldih/themery.nvim",
		config = function()
			themes = {}
			for _, value in pairs(vim.fn.getcompletion("", "color")) do
				themes[#themes + 1] = {
					name = value,
					colorscheme = value,
					after = [[
					vim.cmd("hi WinBar guibg=NONE")
					]],
				}
			end

			if package.config:sub(1, 1) == "\\" then
				themeconfig = vim.fn.stdpath("config") .. "\\lua\\theme.lua"
			else
				themeconfig = vim.fn.stdpath("config") .. "/lua/theme.lua"
			end

			require("themery").setup({
				themes = themes,
				livePreview = true,
				themeConfigFile = themeconfig,
			})
			require("theme")
		end,
		priority = 100,
	},
	{ "catppuccin/nvim", name = "catppuccin", priority = 200 },
	{ "neanias/everforest-nvim", priority = 200 },
	{ "scottmckendry/cyberdream.nvim", priority = 200 },
	{ "rafamadriz/neon", priority = 200 },
	{ "folke/tokyonight.nvim", priority = 200 },
	{ "EdenEast/nightfox.nvim", priority = 200 },
	{
		"Mofiqul/dracula.nvim",
		priority = 200,
	},
	{ "navarasu/onedark.nvim", priority = 200 },
}
