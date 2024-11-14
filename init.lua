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
local g =vim.g
local opt = vim.opt
local o = vim.o
g.mapleader = ","
g.maplocalleader = ","
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
vim.loader.enable()
opt.termguicolors = true
-- For some reason the pacman package the the scoop package have this font named diferently
function getFont()
	return "CaskaydiaCove NF"
end
o.guifont = getFont()
g.python_recommended_style = 0 
g.rust_recommended_style= 0
opt.smartindent = true
opt.expandtab = false
o.tabstop = 4
o.number = true
require("lazy").setup("plugins")
-- load the configs
require("config.ui")
require("config.mason")
require("config.conform")
require("config.dapset")
require("config.cmp")
require("config.keybinds")
require("config.neovide")
