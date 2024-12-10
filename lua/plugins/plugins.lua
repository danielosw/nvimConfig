return {
	{ "nvim-lua/plenary.nvim", lazy = true },
	{
		"AckslD/swenv.nvim",
		ft = "python",
		opts = {
			-- Should return a list of tables with a `name` and a `path` entry each.
			-- Gets the argument `venvs_path` set below.
			-- By default just lists the entries in `venvs_path`.
			get_venvs = function(venvs_path)
				return require("swenv.api").get_venvs(venvs_path)
			end,
			-- Path passed to `get_venvs`.
			venvs_path = vim.fn.expand("~/venvs"),
			-- Something to do after setting an environment, for example call vim.cmd.LspRestart
			post_set_venv = nil,
		},
	},
	"williamboman/mason.nvim",

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = { "lazy.nvim", "mason.nvim", "nvim-dap", "nvim-cmp" },
		},
	},
	{
		"stevearc/overseer.nvim",
		opts = { templates = { "builtin" } },
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "OverseerInfo" },
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		priority = 49,
	},
	{ "windwp/nvim-autopairs", event = "InsertEnter" },
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>f",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		-- This will provide type hinting with LuaLS
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			-- Define your formatters
			-- Set default options
			default_format_opts = {
				lsp_format = "fallback",
			},
			-- Set up format-on-save
			format_on_save = { timeout_ms = 500 },
			-- Customize formatters
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
			},
		},
		init = function()
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
}
