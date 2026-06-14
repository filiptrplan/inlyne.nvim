local M = {}

M.defaults = {
	model = "opencode-go/deepseek-v4-flash",
}

M.options = {}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
