local M = {}

M.start_spinner = function(row)
	local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
	local i = 1
	local ns = vim.api.nvim_create_namespace("spinner")
	local timer = vim.uv.new_timer()
	local mark_id = nil
	local stopped = false
	local buf = vim.api.nvim_get_current_buf()

	timer:start(
		0,
		100,
		vim.schedule_wrap(function()
			if stopped then
				return
			end
			mark_id = vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
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
				vim.api.nvim_buf_del_extmark(buf, ns, mark_id)
			end
		end)
	end
end

M.inline_prompt = function(row, on_submit)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].filetype = "markdown"

	local parent_win = vim.api.nvim_get_current_win()
	local win_width = vim.api.nvim_win_get_width(parent_win)
	local win_height = vim.api.nvim_win_get_height(parent_win)
	local width = math.min(80, math.max(20, win_width - 4))
	local height = 6
	-- place below `row` (buffer line), converted to a window-relative screen row
	local screen_row = row - vim.fn.line("w0", parent_win) + 1
	if screen_row + height + 2 > win_height then
		screen_row = math.max(0, screen_row - height - 3)
	end

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "win",
		win = parent_win,
		row = screen_row,
		col = 0,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
		title = " Inlyne prompt ",
		title_pos = "left",
		footer = " <C-s>/<CR> submit · <Esc>/q cancel ",
		footer_pos = "right",
	})
	vim.wo[win].wrap = true
	vim.wo[win].linebreak = true

	local closed = false
	local function close()
		if closed then
			return
		end
		closed = true
		vim.cmd("stopinsert")
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	local function submit()
		local text = vim.trim(table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n"))
		close()
		if text ~= "" then
			on_submit(text)
		end
	end

	local opts = { buffer = buf, nowait = true }
	vim.keymap.set({ "n", "i" }, "<C-s>", submit, opts)
	vim.keymap.set("n", "<CR>", submit, opts)
	vim.keymap.set("n", "<Esc>", close, opts)
	vim.keymap.set("n", "q", close, opts)

	vim.api.nvim_create_autocmd("WinLeave", { buffer = buf, once = true, callback = close })

	vim.cmd("startinsert")
end

return M
