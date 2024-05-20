dap = require("dap")
Mason_registry = require("mason-registry")
-- define windows
function Iswindows()
	if package.config:sub(1, 1) == "\\" then
		return true
	else
		return false
	end
end
-- Define Daps
dap.configurations.python = {
	{
		-- The first three options are required by nvim-dap
		type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
		request = "launch",
		name = "Launch file",

		-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

		program = "${file}", -- This configuration will launch the current file if used.
		pythonPath = function()
			-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
			-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
			-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
			local cwd = vim.fn.getcwd()
			if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
				return cwd .. "/venv/bin/python"
			elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
				return cwd .. "/.venv/bin/python"
			elseif vim.fn.executable(cwd .. "\\venv\\Scripts\\python.exe") == 1 then
				return cwd .. "\\venv\\Scripts\\python.exe"
			elseif vim.fn.executable(cwd .. "\\.venv\\Scripts\\python.exe") == 1 then
				return cwd .. "\\.venv\\Scripts\\python.exe"
			else
				return vim.fn.exepath("python")
			end
		end,
	},
}
dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
dap.configurations.typescript = {
	{
		name = "Debug with Firefox",
		type = "firefox",
		request = "launch",
		reAttach = true,
		url = "http://localhost:3000",
		webRoot = "${workspaceFolder}",
		firefoxExecutable = function()
			if Iswindows() then
				-- Not yet tested
				return vim.fn.exepath("firefox")
			else
				return "/usr/bin/firefox"
			end
		end,
	},
}
function setupDap(temp)
	if temp == "debugpy" then
		dap.adapters.python = function(cb, config)
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
				if Iswindows() then
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
		if Iswindows() then
			catpath = "\\extension\\adapter\\codelldb"
		else
			catpath = "/extension/adapter/codelldb"
		end
		local templldb = Mason_registry.get_package("codelldb")
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = templldb:get_install_path() .. catpath,
				args = { "--port", "${port}" },
			},
		}
	end
	if temp == "firefox-debug-adapter" then
		if Iswindows() then
			catpath = "\\dist\\adapter.bundle.js"
		else
			catpath = "/dist/adapter.bundle.js"
		end
		local tempfox = Mason_registry.get_package("firefox-debug-adapter")
		dap.adapters.firefox = {
			type = "executable",
			command = "node",
			args = tempfox:get_install_path() .. catpath,
		}
	end
end
-- Get a list of all installed daps
Daps = {}
for _, pkg_info in ipairs(Mason_registry.get_installed_packages()) do
	for _, type in ipairs(pkg_info.spec.categories) do
		if type == "DAP" then
			Daps[#Daps + 1] = pkg_info.name
		end
	end
end
-- Setup list of daps
for _, dap in ipairs(Daps) do
	setupDap(dap)
end
