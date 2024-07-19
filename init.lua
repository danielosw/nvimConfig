local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
function Iswindows()
	if package.config:sub(1, 1) == "\\" then
		return true
	else
		return false
	end
end
if Iswindows() then
	-- set shell to powershell on windows.
	vim.o.shell = "pwsh.exe"
end
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- add mise shims to path if on linux and shims path exists
if
	Iswindows() ~= true
	and function()
			local temp = vim.fn.chdir("~/.local/share/mise/shims")
			if temp ~= "" then
				vim.fn.chdir(temp)
			end
			return temp
		end
		~= ""
then
	vim.env.PATH = vim.env.HOME .. "~/.local/share/mise/shims:" .. vim.env.PATH
end
-- config things that need to be changed before plugins are loaded
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.opt.termguicolors = true
vim.o.guifont = "CaskaydiaCove Nerd Font"
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
require("lazy").setup("plugins")
-- load the configs
require("config.ui")
require("config.mason")
require("config.dapset")
require("config.cmp")
require("config.keybinds")
require("config.neovide")
