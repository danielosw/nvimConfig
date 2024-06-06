return {
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
			require("dapui").setup()
			local listener = require("dap").listeners
			listener.after.event_initialized["dapui_config"] = function()
				require("dapui").open()
			end
		end,
	},
}
