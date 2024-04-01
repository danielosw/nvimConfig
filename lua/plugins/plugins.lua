function IsNotNeovide()
	if not vim.g.neovide then
		return true
	else
		return false
	end
end

return {
	"nvim-lua/plenary.nvim",
	"mhartington/formatter.nvim",
	"Canop/nvim-bacon",
	"AckslD/swenv.nvim",
	{ "stevearc/dressing.nvim", opts = {} },
	"williamboman/mason.nvim",
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Start/Continue Debugger",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Add Breakpoint",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate Debugger",
			},
		},
	},
	"jay-babu/mason-nvim-dap.nvim",
	{
		"anuvyklack/windows.nvim",
		dependencies = { "anuvyklack/middleclass" },
		config = function()
			vim.o.winwidth = 10
			vim.o.winminwidth = 10
			vim.o.equalalways = false
			require("windows").setup()
		end,
	},
	"mfussenegger/nvim-lint",
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
		{ "folke/neodev.nvim", opts = {} },
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		keys = {
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle Debugger UI",
			},
		},
		-- automatically open/close the DAP UI when starting/stopping the debugger
		config = function()
			local listener = require("dap").listeners
			listener.after.event_initialized["dapui_config"] = function()
				require("dapui").open()
			end
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	{ "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
	{ "karb94/neoscroll.nvim", cond = IsNotNeovide },
	{"saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
        require('crates').setup()
    end,
},
"jvgrootveld/telescope-zoxide",
	{"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && yarn install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
},

}
