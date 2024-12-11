local keymap = vim.keymap
local g = vim.g
local o = vim.o
g.neovide_theme = "auto"
g.neovide_no_idle = false
g.neovide_cursor_vfx_mode = "railgun"
keymap.set("v", "<D-c>", '"+y') -- Copy
keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
if Windows then
	g.neovide_title_background_color =
		string.format("%x", vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg)
end

-- You can setup any custom logic for font's here
local function getFont()
	return "CaskaydiaCove NF"
end

o.guifont = getFont()
