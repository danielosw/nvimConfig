local conform = require("conform")
local haveformat = function(bufnr, formatter)
	if conform.get_formatter_info(formatter, bufnr).available then
		return { formatter }
	else
		return { lsp_format = "fallback" }
	end
end
conform.setup({
	formatters_by_ft = {
		lua = function(bufnr)
				return haveformat("stylua", bufnr)
		end,
		rust = function(bufnr)
				return haveformat("rustfmt", bufnr)
		end,

		python = function(bufnr)
				return haveformat("ruff_format", bufnr)
		end,
		typescript = function(bufnr)
			return haveformat(bufnr, "biome")
		end,
		javascript = function(bufnr)
			return haveformat(bufnr, "biome")
		end,
		html = function(bufnr)
			return haveformat(bufnr, "biome")
		end,
		css = function(bufnr)
			return haveformat(bufnr, "biome")
		end,
		c = function(bufnr)
			return haveformat(bufnr, "clang-format")
		end,
		cpp = function(bufnr)
			return haveformat(bufnr, "clang-format")
		end,
		go = function(bufnr)
			return haveformat(bufnr, "gofmt")
		end,
	},
	["*"] = { "codespell" },
})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})
