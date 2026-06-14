local M = {}

M.start_spinner = function(row)
	local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
	local i = 1
	local ns = vim.api.nvim_create_namespace("spinner")
	local timer = vim.uv.new_timer()
	local mark_id = nil
	local stopped = false

	timer:start(
		0,
		100,
		vim.schedule_wrap(function()
			if stopped then
				return
			end
			mark_id = vim.api.nvim_buf_set_extmark(0, ns, row, 0, {
				id = mark_id,
				virt_text = { { frames[i] .. " processing", "Comment" } },
				virt_text_pos = "eol",
			})
			i = (i % #frames) + 1
		end)
	)

	return function()
		stopped = true
		timer:stop()
		timer:close()
		vim.schedule(function()
			if mark_id then
				vim.api.nvim_buf_del_extmark(0, ns, mark_id)
			end
		end)
	end
end

M.inline_prompt = function(row, on_submit)
	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "win",
		row = row,
		col = 0,
		width = 40,
		height = 1,
		style = "minimal",
		border = "rounded",
	})

	vim.api.nvim_buf_set_option(buf, "buftype", "prompt")
	vim.fn.prompt_setprompt(buf, "> ")
	vim.cmd("startinsert")

	vim.fn.prompt_setcallback(buf, function(text)
		vim.api.nvim_win_close(win, true)
		on_submit(text)
	end)

	-- close on escape
	vim.keymap.set("i", "<Esc>", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf })
end

return M
