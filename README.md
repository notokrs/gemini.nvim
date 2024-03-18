# gemini.nvim

A Neovim plugin powered by Google Gemini.

### GeminiCreate

https://github.com/notokrs/gemini.nvim/assets/79308398/11f226b1-eb12-4697-8d76-1ff997a3b735

### GeminiExplain

https://github.com/notokrs/gemini.nvim/assets/79308398/f7adf096-2fba-4a75-95e0-3926a303983c

## Installation

First [get an API key](https://ai.google.dev/tutorials/setup) from Gemini. It's free!

Using lazy.nvim:

```lua
{
  'notokrs/gemini.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  opts = {
    api_key = 'YOUR_GEMINI_API_KEY', -- or read from env: `os.getenv('GEMINI_API_KEY')`
    -- The language for the content to be defined/translated into
    language = 'indonesia',
    -- The locale for the content in the locale above to be translated into
    second_language = 'english',
    -- Gemini's answer is displayed in split window
    -- Define custom prompts here, see below for more details
    prompts = {},
  },
  event = 'VeryLazy',
},
```

## Usage

### Built-in Commands

```viml
" Create code using selected text or passed to the command
:'<,'>GeminiCreate
:GeminiCreate function to check palindrome

" Explain selected code
:'<,'>GeminiExplain

" Translate content selected or passed to the commmand
:'<,'>GeminiTranslate
:GeminiTranslate I am happy.

" Improve content selected or passed to the command
:'<,'>GeminiImprove

" Useful to correct grammar mistakes and make the expressions more native.
:GeminiTranslate Me is happy.

" Ask anything
:GeminiAsk Tell a joke.
```

### Custom Prompts

```lua
opts = {
  prompts = {
    rock = {
      -- Create a user command for this prompt
      command = 'GeminiRock',
      loading_tpl = 'Loading...',
      prompt_tpl = 'Tell a joke',
      result_tpl = 'Here is your joke:\n\n$output',
      require_input = false,
      open_window = true,
    },
  },
}
```

The prompts will be merged into built-in prompts. Here are the available fields for each prompt:

| Fields          | Required | Description                                                                                             |
| --------------- | -------- | ------------------------------------------------------------------------------------------------------- |
| `command`       | No       | If defined, a user command will be created for this prompt.                                             |
| `loading_tpl`   | No       | Template for content shown when communicating with Gemini. See below for available placeholders.        |
| `prompt_tpl`    | Yes      | Template for the prompt string passed to Gemini. See below for available placeholders.                  |
| `result_tpl`    | No       | Template for the result shown in the popup. See below for available placeholders.                       |
| `require_input` | No       | If set to `true`, the prompt will only be sent if text is selected or passed to the command.            |
| `open_window`   | No       | If set to `true`, output will open in split window. if `false`, output will write directly into buffer. |

Placeholders can be used in templates. If not available, it will be left as is.

| Placeholders         | Description                                                                                | Availability      |
| -------------------- | ------------------------------------------------------------------------------------------ | ----------------- |
| `${language}`        | `opts.language`                                                                            | Always            |
| `${second_language}` | `opts.second_language`                                                                     | Always            |
| `${input}`           | The text selected or passed to the command.                                                | Always            |
| `${input_encoded}`   | The text encoded with JSON so that Gemini will take it as literal instead of a new prompt. | Always            |
| `${output}`          | The result returned by Gemini.                                                             | After the request |

We can either call a prompt with the associated command:

```viml
:GeminiRock
```

or with its name:

```viml
:lua require('ai').handle('rock')
```

## Related Projects

- [coc-ai](https://github.com/gera2ld/coc-ai) - A coc.nvim plugin powered by Gemini
