Mason_registry = require("mason-registry")
local  dapui =  require("dapui")
Dap = require("dap")
Dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
-- For preformence reasons Daps are now defined in ftplugin files

-- Takes in a string and configs a matching dap.
-- The reason I do it this way is so it does not crash if a dap is not installed, because some of configs require it to be installed in mason.
function setupDap(temp)
	if temp == "debugpy" then
		Dap.adapters.python = function(cb, config)
			if config.request == "attach" then
				local port = (config.connect or config).port
				local host = (config.connect or config).host or "127.0.0.1"
				cb({
					type = server,
					port = assert(port, "connect.port is required for a python attach configuration"),
					host = host,
					options = {
						source_filetype = "python",
					},
				})
			else
				local pypath = Mason_registry.get_package("debugpy")
				if Windows then
					catpath = "\\venv\\scripts\\python"
				else
					catpath = "/venv/bin/python"
				end
				cb({
					type = "executable",
					command = pypath:get_install_path() .. catpath,
					args = { "-m", "debugpy.adapter" },
					options = {
						source_filetype = "python",
					},
				})
			end
		end
	end
	if temp == "codelldb" then
		if Windows then
			catpath = "\\extension\\adapter\\codelldb"
		else
			catpath = "/extension/adapter/codelldb"
		end
		local templldb = Mason_registry.get_package("codelldb")
		Dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = templldb:get_install_path() .. catpath,
				args = { "--port", "${port}" },
			},
		}
	end
	if temp == "firefox-debug-adapter" then
		if Windows then
			catpath = "\\dist\\adapter.bundle.js"
		else
			catpath = "/dist/adapter.bundle.js"
		end
		local tempfox = Mason_registry.get_package("firefox-debug-adapter")
		Dap.adapters.firefox = {
			type = "executable",
			command = "node",
			args = tempfox:get_install_path() .. catpath,
		}
	end
end
-- Get a list of all installed daps and setup any found
	for _, founddap in ipairs(Daps) do
			setupDap(founddap)
	end
