# inlyne.nvim

Call the [pi](https://github.com/earendil-works/pi-coding-agent) CLI agent inline from Neovim.

## Why another plugin?

All of the other plugins add too much functionality. This plugin seeks to accomplish only one thing: triggering multiple short code edits at a time, quickly. No asking questions, no fancy extensions. We use Pi exactly because it is a minimal agent coding harness and we disable all extensions and skills when we call it. 

## Requirements

- [pi](https://github.com/earendil-works/pi-coding-agent) installed and on `$PATH`

## Install

```lua
-- lazy.nvim
{ "filiptrplan/inlyne.nvim" }
```

## Usage

- `:InlynePrompt` — opens a floating prompt, sends your input to pi
- `:InlyneCall <message>` — sends a message directly (no prompt UI)
- `:InlyneKill` -- Kills all running instances of Pi.

Both commands also accept a range and that is communicated to Pi.

## Config

```lua
-- lazy.nvim with custom model
{ "filiptrplan/inlyne.nvim", opts = { model = "opencode-go/deepseek-v4-flash" } }
```

Default model: `opencode-go/deepseek-v4-flash`.

## License

MIT
