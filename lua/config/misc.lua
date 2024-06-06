require("lualine").setup({
	options = {
		theme = "auto",
	},
})
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end

require("telescope").load_extension("zoxide")
