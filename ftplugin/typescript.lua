dap = require("dap")
dap.configurations.typescript = {
	{
		name = "Debug with Firefox",
		type = "firefox",
		request = "launch",
		reAttach = true,
		url = "http://localhost:3000",
		webRoot = "${workspaceFolder}",
		firefoxExecutable = function()
			if Windows then
				-- Not yet tested
				return vim.fn.exepath("firefox")
			else
				return "/usr/bin/firefox"
			end
		end,
	},
}
