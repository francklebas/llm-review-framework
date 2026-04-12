# llm-review-framework

LLM-powered code review as a pre-commit hook. Works with any LLM provider, any project.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/francklebas/llm-review-framework/main/install.sh | bash
```

## Setup a project

```bash
cd your-project
llmfwk init
```

The interactive setup will:

1. Ask which LLM provider to use (Gemini, Ollama, Claude, OpenAI, Mistral, Groq, GitHub Copilot, or custom)
2. Check if the provider CLI is installed (and offer to install it)
3. Let you pick a model
4. Check if pre-commit is installed (and offer to install it)
5. Optionally create project-specific prompts from templates
6. Write `.llm-review.yaml` and `.pre-commit-config.yaml`

## How it works

On every commit, the `llm-codereview` hook:

1. Reads your `.llm-review.yaml` config
2. Gets the staged diff
3. Loads review prompts (project-specific or base defaults)
4. Sends everything to your LLM provider
5. Outputs a markdown code review

The output is readable by you **and** exploitable by the LLM in your editor (Claude Code, opencode, Cursor, etc.).

## Prompts

### Base prompts (built-in)

If you skip project-specific prompts during `llmfwk init`, the hook uses universal code quality prompts covering SOLID, DRY, security, error handling, and common anti-patterns.

### Project-specific prompts

For tailored reviews, create prompts for your project:

```
~/.llmfwk/prompts/projects/your-project/
  codereview-context.md      # Your stack, architecture, conventions
  codereview-guidelines.md   # Review focus areas, framework-specific checks
```

Templates are provided during `llmfwk init` to guide you.

## Supported providers

| Provider | CLI | Notes |
|----------|-----|-------|
| Gemini | `gemini` | Free tier available |
| Ollama | `ollama` | Local, no API key needed |
| Claude | `claude` | Anthropic Claude Code CLI |
| OpenAI | `openai` | GPT-4o and variants |
| Mistral | `mistral` | Codestral for code |
| Groq | `groq` | Fast inference |
| GitHub Copilot | `gh copilot` | Via gh CLI extension |
| Custom | any | Pipe prompt to your own command |

## Configuration

`.llm-review.yaml` at your project root:

```yaml
provider: gemini
model: gemini-2.5-flash-lite
prompts_dir: ~/.llmfwk/prompts/projects
```

## License

[AGPL-3.0](LICENSE)
