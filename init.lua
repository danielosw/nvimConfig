local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
function Iswindows()
	if package.config:sub(1, 1) == "\\" then
		return true
	else
		return false
	end
end
if Iswindows() then
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
function IsNotNeovide()
	if not vim.g.neovide then
		return true
	else
		return false
	end
end
if Iswindows() ~= true then
	vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
end
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.opt.termguicolors = true
vim.o.guifont = "CaskaydiaCove Nerd Font"
require("lazy").setup("plugins")
-- load the configs
require("config.noice")
require("config.mason")
require("config.dapset")
require("config.cmp")
require("config.keybinds")
require("config.neovide")
require("config.misc")
