local M = {}

function M.assign(table, other)
	for k, v in pairs(other) do
		table[k] = v
	end

	return table
end

function M.fill(tpl, args)
	if tpl == nil then
		tpl = ""
	else
		for key, value in pairs(args) do
			tpl = string.gsub(tpl, "%${" .. key .. "}", value)
		end
	end

	return tpl
end

function M.splitLines(input)
	local lines = {}
	local offset = 1

	while offset > 0 do
		local i = string.find(input, "\n", offset)

		if i == nil then
			table.insert(lines, string.sub(input, offset, -1))
			offset = 0
		else
			table.insert(lines, string.sub(input, offset, i - 1))
			offset = i + 1
		end
	end

	return lines
end

function M.joinLines(lines)
	local result = ""

	for _, line in ipairs(lines) do
		result = result .. line .. "\n"
	end

	return result
end

function M.isEmpty(text)
	return text == nil or text == ""
end

function M.hasLetters(text)
	return type(text) == "string" and text:match("[a-zA-Z]") ~= nil
end

function M.getSelectedText(esc)
	if esc then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", false)
	end

	local vstart = vim.fn.getpos("'<")
	local vend = vim.fn.getpos("'>")
	-- If the selection has been made under VISUAL mode:
	local ok, lines = pcall(vim.api.nvim_buf_get_text, 0, vstart[2] - 1, vstart[3] - 1, vend[2] - 1, vend[3], {})
	if ok then
		return M.joinLines(lines)
	else
		-- If the selection has been made under VISUAL LINE mode:
		lines = vim.api.nvim_buf_get_lines(0, vstart[2] - 1, vend[2], false)
		return M.joinLines(lines)
	end
end

function M.formatResult(data)
	local result = ""
	local candidates_number = #data["candidates"]

	if candidates_number == 1 then
		if data["candidates"][1]["content"] == nil then
			result = "Gemini stoped with the reason:" .. data["candidates"][1]["finishReason"] .. "\n"
			return result
		else
			result = "# There is only 1 candidate\n"
			result = result .. data["candidates"][1]["content"]["parts"][1]["text"] .. "\n"
		end
	else
		result = "## There are " .. candidates_number .. " candidates\n"
		for i = 1, candidates_number do
			result = result .. "### Candidate number " .. i .. "\n"
			result = result .. data["candidates"][i]["content"]["parts"][1]["text"] .. "\n"
		end
	end

	return result
end

function M.formatCode(data)
	if data == nil then
		M.notify_err("Response is empty, try again later")
	end

	local result = ""

	if data["candidates"][1]["content"] == nil then
		result = "Gemini stoped with the reason:" .. data["candidates"][1]["finishReason"] .. "\n"
		return result
	else
		result = data["candidates"][1]["content"]["parts"][1]["text"] .. "\n"

		result = result:gsub("```[a-z]+\n", "")
		result = result:gsub("```", "")
	end

	return result
end

function M.notify(message)
	local string = "'msg'"

	vim.api.nvim_exec("echo" .. string:gsub("msg", message), false)
end

function M.notify_err(message)
	local string = "'msg'"

	vim.api.nvim_exec("echoerr" .. string:gsub("msg", message), false)
end

return M
