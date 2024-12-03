local cwd = vim.fn.getcwd()

local function getPython()
	do
		if vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
			return cwd .. "/.venv/bin/python"
		elseif vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
			return cwd .. "/venv/bin/python"
		elseif vim.fn.executable(cwd .. "\\.venv\\Scripts\\python.exe") == 1 then
			return cwd .. "\\.venv\\Scripts\\python.exe"
		elseif vim.fn.executable(cwd .. "\\.venv\\Scripts\\python.exe") == 1 then
			return cwd .. "\\.venv\\Scripts\\python.exe"
		else
			return vim.fn.exepath("python")
		end
	end
end
PythonPath = getPython()
