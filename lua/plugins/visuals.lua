return {
	"nvim-lualine/lualine.nvim",
	"danielosw/rainbow-delimiters.nvim",
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
		event = "VeryLazy",
		config = function()
			require("bufferline").setup({
				options = {
					separator_style = "slant",
					themable = true,
				},
			})
		end,
	},
	{
		"gorbit99/codewindow.nvim",
		config = function()
			local codewindow = require("codewindow")
			codewindow.setup()
			codewindow.apply_default_keybinds()
		end,
	},
	{
		"rachartier/tiny-devicons-auto-colors.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
		config = function()
			require("tiny-devicons-auto-colors").setup()
		end,
	},
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

	{
		"goolord/alpha-nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("alpha").setup(require("alpha.themes.dashboard").config)
		end,
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
	},
	{
		"SmiteshP/nvim-navbuddy",
		dependencies = {
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
		},
		event = "VeryLazy",
	},
	{
		"RRethy/vim-illuminate",
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
		config = function()
			-- optionally enable 24-bit colour
			vim.opt.termguicolors = true
			require("nvim-tree").setup({
				hijack_unnamed_buffer_when_opening = true,
				hijack_netrw = true,
			})
		end,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
	},
}
