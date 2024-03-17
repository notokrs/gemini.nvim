local M = {}
local utils = require("gemini.utils")
local glow = require("gemini.glow")

local win_id = {}

function M.write_to_buffer(result)
	if result == nil then
		result = ""
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = cursor[1]

	local activeBuffer = vim.api.nvim_get_current_buf()
	local lines = utils.splitLines(result)

	vim.api.nvim_buf_set_lines(activeBuffer, line, line, true, lines)
	utils.notify("Complete")
end

function M.open_window(result, use_glow)
	M.close_window()

	if result == nil then
		result = ""
	end

	local bufnr = vim.api.nvim_create_buf(false, true)
	local lines = utils.splitLines(result)

	-- vim.bo[bufnr].modifiable = true
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
	-- vim.bo[bufnr].modifiable = false

	vim.cmd.split({ mods = { vertical = true } })
	win_id = vim.api.nvim_get_current_win()

	if use_glow then
		local file = glow.create_file(bufnr)
		glow.run_glow(file, win_id)
	else
		vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")
		vim.api.nvim_win_set_buf(win_id, bufnr)
	end
end

function M.close_window()
	if win_id == nil then
		return
	end

	pcall(vim.api.nvim_win_close, win_id, true)
	win_id = nil
end

return M
