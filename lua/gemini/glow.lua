local utils = require("gemini.utils")
local M = {}

local function cleanup(file)
	if file ~= nil then
		vim.fn.delete(file)
	end
end

function M.create_file(bufnr)
	local output = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	if vim.tbl_isempty(output) then
		utils.notify_err("Buffer is empty")
		return ""
	end

	local tmp = vim.fn.tempname() .. ".md"
	vim.fn.writefile(output, tmp)

	return tmp
end

function M.run_glow(file, win_id)
	if vim.fn.executable("glow") == 0 then
		utils.notify_err("Glow not installed")
		return
	end

	if file ~= nil and file ~= "" then
		if not vim.fn.filereadable(file) then
			utils.notify_err("Error when reading file")
			return
		end
	end

	local bufnr = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_option(bufnr, "buflisted", false)
	vim.api.nvim_buf_set_option(bufnr, "filetype", "terminal")
	vim.api.nvim_win_set_buf(win_id, bufnr)

	vim.wo.relativenumber = false
	vim.wo.number = false

	local on_exit = function()
		cleanup(file)
	end

	vim.fn.termopen("glow " .. file, {
		on_exit = on_exit,
	})

	vim.cmd("startinsert")
end

return M
