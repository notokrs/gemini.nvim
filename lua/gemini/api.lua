local curl = require("plenary.curl")
local utils = require("gemini.utils")
local processor = require("gemini.processor")
local M = {}

function M.askGeminiCallback(res, opts)
  local result
  local data

  if res.status ~= 200 then
    if opts.handleError ~= nil then
      result = opts.handleError(res.status, res.body)
    else
      result = "Error: Gemini API responded with the status " .. tostring(res.status) .. "\n\n" .. res.body
    end
  else
    data = vim.fn.json_decode(res.body)
    result = utils.formatResult(data)

    if opts.handleResult ~= nil then
      result = opts.handleResult(result)
    end
  end

  if opts.open_window then
    processor.open_window(result, opts.use_glow)
  else
    processor.write_to_buffer(utils.formatCode(data))
  end
end

function M.askGemini(prompt, api_key, opts)
  curl.post("https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=" .. api_key, {
    raw = { "-H", "Content-type: application/json" },
    body = vim.fn.json_encode({
      contents = {
        {
          parts = {
            text = prompt,
          },
        },
      },
    }),
    callback = function(res)
      vim.schedule(function()
        M.askGeminiCallback(res, opts)
      end)
    end,
  })
end

return M
