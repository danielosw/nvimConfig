setuptheme = function(theme)
	themes = {}
	if theme == "cyberdream" then
		themes[#themes + 1] = {
			name = "cyberdream dark",
			colorscheme = "cyberdream",
			before = [[
	vim.o.background = "dark",
	require("cyberdream").setup({
	    theme = {
		variant = "default",
	    },
	})
	]],
			after = [[
	vim.cmd("hi WinBar guibg=NONE")
	]],
		}
		themes[#themes + 1] = {
			name = "cyberdream light",
			colorscheme = "cyberdream",
			before = [[
vim.o.background = "light",
			
	require("cyberdream").setup({
	    theme = {
		variant = "light",
	    },
	})
	]],
			after = [[
	vim.cmd("hi WinBar guibg=NONE")
	]],
		}
	elseif theme == "neon" then
		themes[#themes + 1] = {

			name = "neon default",
			colorscheme = "neon",
			before = [[
vim.o.background = "dark"
			
	vim.g.neon_style = "default"
	]],
			after = [[
	vim.cmd("hi WinBar guibg=NONE")
	]],
		}
		themes[#themes + 1] = {
			name = "neon doom",
			colorscheme = "neon",
			before = [[
vim.o.background = "dark"
			
	vim.g.neon_style = "doom"
	]],
			after = [[
	vim.cmd("hi WinBar guibg=NONE")
	]],
		}
		themes[#themes + 1] = {
			name = "neon dark",
			colorscheme = "neon",
			before = [[
vim.o.background = "dark"
			
	vim.g.neon_style = "dark"
	]],
			after = [[
	vim.cmd("hi WinBar guibg=NONE")
	]],
		}
		themes[#themes + 1] = {
			name = "neon light",
			colorscheme = "neon",
			before = [[
vim.o.background = "light"
			
	vim.g.neon_style = "light"
	]],
			after = [[
	vim.cmd("hi WinBar guibg=NONE")
	]],
		}
	elseif theme == "oxocarbon" then
		themes[#themes + 1] = {
			name = "oxocarbon dark",
			colorscheme = "oxocarbon",
			before = [[
	    vim.o.background = "dark"
	    ]],
			after = [[vim.cmd("hi WinBar guibg=NONE")]],
		}
		themes[#themes + 1] = {
			name = "oxocarbon light",
			colorscheme = "oxocarbon",
			before = [[
	    vim.o.background = "light"
	    ]],
			after = [[vim.cmd("hi WinBar guibg=NONE")]],
		}
	elseif theme == "dracula" then
		themes[#themes + 1] = {
			name = "dracula",
			colorscheme = "dracula",
		}
	end
	return themes
end
tablemerge = function(tableone, tabletwo)
	for _, v in ipairs(tabletwo) do
		tableone[#tableone + 1] = v
	end
	return tableone
end
return {
	{
		"zaldih/themery.nvim",
		config = function()
			themes = {}
			specialthemes = { "cyberdream", "neon", "oxocarbon", "dracula" }
			for _, value in pairs(vim.fn.getcompletion("", "color")) do
				-- MASSIVE hack to simplify checking for some themes.
				Temp = true
				for _, i in ipairs(specialthemes) do
					if value == i then
						Temp = false
					end
				end

				if Temp then
					themes[#themes + 1] = {
						name = value,
						colorscheme = value,
					}
				else
					themes = tablemerge(themes, setuptheme(value))
				end
			end

			require("themery").setup({
				themes = themes,
				livePreview = true,
			})
		end,
		priority = 100,
	},

	{ "catppuccin/nvim", name = "catppuccin", priority = 200 },
	{ "neanias/everforest-nvim", priority = 200 },
	{ "scottmckendry/cyberdream.nvim", priority = 200 },
	{ "rafamadriz/neon", priority = 200 },
	{ "folke/tokyonight.nvim", priority = 200 },
	{ "EdenEast/nightfox.nvim", priority = 200 },
	{
		"Mofiqul/dracula.nvim",
		priority = 200,
		config = function()
			require("dracula").setup({
				show_end_of_buffer = false,
				transparent_bg = false,
				italic_comment = false,
				lualine_bg_color = nil,
				colors = {},
				overrides = {
					WinBar = { bg = "bg" },
					WinBarNC = { bg = "bg" },
					TabLineSel = { bg = "bg" },
				},
			})
		end,
	},
	{ "nyoom-engineering/oxocarbon.nvim", priority = 200 },
	{ "navarasu/onedark.nvim", priority = 200 },
}
