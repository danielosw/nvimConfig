local conform = require("conform")
haveformat = function(bufnr, formatter)
	if conform.get_formatter_info(formatter, bufnr).available then
		return { formatter }
	else
		return { lsp_format = "fallback" }
	end
end
conform.setup({
	formatters_by_ft = {
		lua = function(bufnr)
			if conform.get_formatter_info("stylua", bufnr).available then
				return { "stylua" }
			else
				return { lsp_format = "fallback" }
			end
		end,
		rust = function(bufnr)
			if conform.get_formatter_info("rustftm", bufnr).available then
				return { "rustftm" }
			else
				return { lsp_format = "fallback" }
			end
		end,

		python = function(bufnr)
			if require("conform").get_formatter_info("ruff_format", bufnr).available then
				return { "ruff_format" }
			else
				return {lsp_format = "fallback"}
			end
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
