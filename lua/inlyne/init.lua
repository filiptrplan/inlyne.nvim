local M = {}

local rpc = require("inlyne.pi")
local config = require("inlyne.config")
local ui = require("inlyne.ui")

M.setup = function(opts)
	config.setup(opts)
	M.register_commands()
end

M.register_commands = function()
	vim.api.nvim_create_user_command("InlynePrompt", function(opts)
		local row = vim.api.nvim_win_get_cursor(0)[1]
		if opts.range > 0 then
			row = opts.line2
		end
		ui.inline_prompt(row, function(prompt)
			if opts.range > 0 then
				rpc.call_with_range(opts.line1, opts.line2, prompt, config.options.model)
			else
				rpc.call(prompt, config.options.model)
			end
		end)
	end, { nargs = 0, desc = "Triggers inline prompt and then calls agent with user input", range = true })

	vim.api.nvim_create_user_command("InlyneCall", function(opts)
		if opts.range > 0 then
			rpc.call_with_range(opts.line1, opts.line2, opts.fargs[1], config.options.model)
		else
			rpc.call(opts.fargs[1], config.options.model)
		end
	end, {
		nargs = 1,
		desc = "Calls the Pi agent inline",
		range = true,
	})
end

return M
