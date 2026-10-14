# inlyne.nvim

Call the [pi](https://github.com/earendil-works/pi-coding-agent) CLI agent inline from Neovim.

## Why another plugin?

All of the other plugins add too much functionality. This plugin seeks to accomplish only one thing: triggering multiple short code edits at a time, quickly. No asking questions, no fancy extensions. We use Pi exactly because it is a minimal agent coding harness and we disable all extensions and skills when we call it. 

## Requirements

- [pi](https://github.com/earendil-works/pi-coding-agent) installed and on `$PATH` (default backend), or
- [Claude Code](https://claude.com/claude-code) installed and on `$PATH` (`backend = "claude"`)

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
-- lazy.nvim using Claude Code with Haiku
{ "filiptrplan/inlyne.nvim", opts = { backend = "claude" } }

-- custom model
{ "filiptrplan/inlyne.nvim", opts = { backend = "pi", model = "opencode-go/deepseek-v4-flash" } }
```

- `backend`: `"pi"` (default) or `"claude"`.
- `model`: defaults to `opencode-go/deepseek-v4-flash` for pi and `haiku` for claude.

The claude backend runs `claude -p` with `acceptEdits` and only the `Read,Edit,Write,Grep,Glob` tools allowed.

## License

MIT
