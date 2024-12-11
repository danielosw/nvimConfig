return {
	{
		"MunifTanjim/nougat.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("config.nougat")
		end,
	},
	{
		"hiphish/rainbow-delimiters.nvim",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				separator_style = "slant",
				themable = true,
			},
		},
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"gorbit99/codewindow.nvim",
		config = function()
			local codewindow = require("codewindow")
			codewindow.setup()
			codewindow.apply_default_keybinds()
		end,
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"rachartier/tiny-devicons-auto-colors.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
	},

	{
		"goolord/alpha-nvim",
	},
	{
		"SmiteshP/nvim-navic",
		opts = {
			lsp = {
				auto_attach = false,
				preference = nil,
			},
			highlight = true,
			separator = " > ",
			depth_limit = 10,
			depth_limit_indicator = "..",
			click = true,
		},
		lazy = true,
	},
	{
		"SmiteshP/nvim-navbuddy",
		dependencies = {
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
		},
		lazy = true,
	},
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	{
		"nvchad/minty",
		cmd = { "Shades", "Huefy" },
		dependencies = {
			"nvchad/volt",
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = { hijack_unnamed_buffer_when_opening = true, hijack_netrw = true },
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
}
