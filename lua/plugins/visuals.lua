return {
	"nvim-lualine/lualine.nvim",
	"HiPhish/rainbow-delimiters.nvim",
	{"folke/noice.nvim",
	event = "VeryLazy",
	opts = {},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	},
		{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
	},
	{ "anuvyklack/animation.nvim", cond = IsNotNeovide },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	},
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },


}
