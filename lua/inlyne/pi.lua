local M = {}

local ui = require("inlyne.ui")

local SYSTEM_PROMPT = [[
You are being called in INLINE mode straight from the user's IDE. Your mission is to complete the user's request as fast as possible, prioritizing simplicity and low-cost edits above verification and engineering. 

Rules:
- Try not to open too many additional files if not directly relevant to the user request.
- Open files to check call signatures, intefaces, APIs, and coding conventions
- No need to be verbose in the chat or provide a summary of what you did as the user doesn't see your output, only your edits.
- No need to add any caveats, next steps or questions as the user does not see that either.
]]

M.call_with_range = function(start_line, end_line, user_message, model)
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	local text = table.concat(lines, "\n")
	user_message = user_message .. string.format("\n\nUser selected lines %d - %d: \n%s", start_line, end_line, text)
	M.call(user_message, model)
end

M.call = function(user_message, model)
	local current_file = vim.api.nvim_buf_get_name(0)
	local message = string.format(
		[[
File to edit: %s

User prompt: %s
  ]],
		current_file,
		user_message
	)

	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	local stop_spinner = ui.start_spinner(row)
	local handle, pid = vim.uv.spawn("pi", {
		args = { "--model", model, "--no-extensions", "--no-skills", "--append-system-prompt", SYSTEM_PROMPT, message },
		stdio = { nil, nil, nil },
	}, function(code, signal)
		vim.schedule(function()
			vim.cmd("edit!")
			stop_spinner()
		end)
	end)
end

return M
