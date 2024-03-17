local default_prompts = require("gemini.default_prompts")
local utils = require("gemini.utils")
local api = require("gemini.api")
local processor = require("gemini.processor")

local M = {}

M.opts = {
	api_key = "",
	language = "indonesia",
	second_language = "english",
	use_glow = true,
}
M.prompts = default_prompts

function M.handle(name, input)
	local def = M.prompts[name]

	local args = {
		language = M.opts.language,
		second_language = M.opts.second_languaged,
		filetype = vim.bo.filetype,
		input = input,
		input_encoded = vim.fn.json_encode(input),
	}

	local initialContent = utils.fill(def.loading_tpl, args)
	local prompt = utils.fill(def.prompt_tpl, args)

	if def.open_window then
		processor.open_window(initialContent, M.opts.use_glow)
	else
		utils.notify("Asking Gemini...")
	end

	api.askGemini(prompt, M.opts.api_key, {
		handleResult = function(output)
			args.output = output
			return utils.fill(def.result_tpl or "${output}", args)
		end,
		open_window = def.open_window,
		use_glow = M.opts.use_glow,
	})
end

function M.setup(opts)
	for k, v in pairs(opts) do
		if k == "prompts" then
			M.prompts = {}
			utils.assign(M.prompts, default_prompts)
			utils.assign(M.prompts, v)
		elseif M.opts[k] ~= nil then
			M.opts[k] = v
		end
	end

	assert(M.opts.api_key ~= nil and M.opts.api_key ~= "", "api_key is required")

	for k, v in pairs(M.prompts) do
		if v.command then
			vim.api.nvim_create_user_command(v.command, function(args)
				local text = args["args"]
				local selected_text = utils.getSelectedText(true)

				if utils.hasLetters(text) and utils.hasLetters(selected_text) then
					text = text .. "\n\n" .. selected_text
				end

				if utils.isEmpty(text) then
					text = selected_text
				end

				if not v.require_input or utils.hasLetters(text) then
					-- delayed so the popup won't be closed immediately
					vim.schedule(function()
						M.handle(k, text)
					end)
				end
			end, { range = true, nargs = "?" })
		end
	end
end

-- vim.keymap.set("n", "<Esc>", processor.close_window, { noremap = true })
vim.keymap.set("n", "q", processor.close_window, { noremap = true })

return M
