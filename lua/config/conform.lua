local conform = require("conform")
-- Function to make the default setup more conveniunt
local haveformat = function(bufnr, formatter)
	if conform.get_formatter_info(formatter, bufnr).available then
		return { formatter }
	else
		return { lsp_format = "fallback" }
	end
end
-- we want to enable both ruff_format and ruff_fix if possible
local haveRuff = function(bufnr)
	local toReturn = {}
	if conform.get_formatter_info("ruff_format", bufnr).available then
		toReturn[#toReturn + 1] = "ruff_format"
	end
	if conform.get_formatter_info("ruff_fix", bufnr).available then
		toReturn[#toReturn + 1] = "ruff_fix"
	end
	if #toReturn == 0 then
		return { lsp_format = "fallback" }
	end
	return toReturn
end
conform.setup({
	formatters_by_ft = {
		lua = function(bufnr)
			return haveformat("stylua", bufnr)
		end,
		-- I can't figure out how do to this without hard coding it
		rust = { "rustfmt" },
		python = function(bufnr)
			return haveRuff(bufnr)
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
-- format on write
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
