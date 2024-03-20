dap = require("dap")
Mason_registry = require("mason-registry")
-- define windows
function Iswindows()
	if (package.config:sub(1,1) == "\\")
		then
			return true
		else
			return false
		end
end
-- Define Daps
dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
	if Iswindows() then
		return 'C:\\Users\\lorde\\AppData\\Local\\Programs\\Python\\Python312\\python.exe'	
	else
		return '/usr/bin/python'
      end
      end
    end;
  },
}
function setupDap(temp)
	if temp == "debugpy" then
		dap.adapters.python = function(cb, config)
			if config.request == 'attach' then 
				local port = (config.connect or config).port
				local host = (config.connect or config).host or '127.0.0.1'
				cb({
					type = server,
					port = assert(port, 'connect.port is required for a python attach configuration'),
					host = host,
					options = {
						source_filetype = 'python',
					},
				})
			else
				local pypath = Mason_registry.get_package("debugpy")
				if Iswindows() then
					catpath = "\\venv\\scripts\\python"
				else
					catpath = "/venv/scripts/python"
				end
				cb({
					type = 'executable',
					command = pypath:get_install_path() .. catpath,
					args = {'-m', 'debugpy.adapter'},
					options = {
						source_filetype = 'python',
					},
				})
			end

		end
	end
end
-- Get a list of all installed daps
Daps = {}
for _, pkg_info in ipairs(Mason_registry.get_installed_packages()) do
	for _, type in ipairs(pkg_info.spec.categories) do
		if type == "DAP" then
			Daps[#Daps+1] = pkg_info.name
		end
	end
end
-- Setup list of daps
for _, dap in ipairs(Daps) do
	setupDap(dap)
end

