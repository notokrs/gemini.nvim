local default_prompts = {
	translate = {
		command = "GeminiTranslate",
		loading_tpl = "# Translating the content below:\n${input}\n### Asking Gemini...",
		prompt_tpl = "Translate the content below into ${language}. Translate into ${second_language} instead if it is already in ${language}. Do not return anything else. Here is the content:\n${input_encoded}",
		result_tpl = "# Original Content:\n${input}\n# Translation:\n${output}",
		require_input = true,
		open_window = true,
	},
	freeStyle = {
		command = "GeminiAsk",
		loading_tpl = "# Question:\n${input}\n ### Asking Gemini...",
		prompt_tpl = "${input}",
		result_tpl = "# Question:\n${input}\n# Answer:\n${output}",
		require_input = true,
		open_window = true,
	},
	create = {
		command = "GeminiCreate",
		loading_tpl = "",
		prompt_tpl = "Generate the code below in ${filetype}. Do not return anything else. Here is the details:\n${input}",
		result_tpl = "${output}",
		require_input = true,
		open_window = false,
	},
	explain = {
		command = "GeminiExplain",
		loading_tpl = "# Explain the code below:\n${input}\n### Asking Gemini...",
		prompt_tpl = "Explain this code. Explain in ${language}. Here is the code: \n${input}.",
		result_tpl = "# Question:\n${input}\n# Explaination:\n${output}",
		require_input = true,
		open_window = true,
	},
	improve = {
		command = "GeminiImprove",
		loading_tpl = "# Improve the code below:\n${input}\n### Asking Gemini...",
		prompt_tpl = "Improve the code below. Explain briefly the improved code using ${language}. Here is the code:\n\n${input}",
		result_tpl = "# Original Content:\n${input}\n# Improved Content:\n${output}",
		require_input = true,
		open_window = true,
	},
}

return default_prompts
