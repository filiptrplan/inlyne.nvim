local M = {}

M.defaults = {
	-- "pi" or "claude" (Claude Code)
	backend = "pi",
	-- nil uses the backend default ("opencode-go/deepseek-v4-flash" for pi, "haiku" for claude)
	model = nil,
}

M.options = {}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
