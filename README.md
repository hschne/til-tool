<div align="center">

# TIL Tool

A simple bash script to manage and create "Today I Learned" notes from the command line.

![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)

</div>

## What are TIL Notes?

TIL ("Today I Learned") notes are brief documents that record new snippets of knowledge you acquire daily. They have become a popular way for developers to document their learning journey, inspired by repositories like [jbranchaud/til](https://github.com/jbranchaud/til) and [thoughtbot/til](https://github.com/thoughtbot/til).

TILs are typically:

- Short markdown documents (a few paragraphs at most)
- Focus on a single bit of knowledge
- Organized by topics through directories or tags

## Features

- ✨ Create properly formatted markdown TIL notes with a single command
- 🏷️ Add tags to organize your knowledge
- 📅 Automatically add dates and format filenames consistently
- 📝 Custom templates support
- 🔄 Git integration for automatic commits and pushes
- 📂 Configurable storage location

## Installation

Clone this repository and link the script to a location on your path:

```bash
# Clone the repository
git clone https://github.com/your-username/til-tool.git

# Make the script executable
chmod +x til-tool/til

# Link the script to your path (optional)
ln -s "$(pwd)/til-tool/til" ~/.local/bin/til
```

## Usage

Create a new TIL note:

```bash
til "Using fzf for Fuzzy Finding"
```

This will:

1. Create a new markdown file with today's date
2. Format the filename as `YYYY-MM-DD-using-fzf-for-fuzzy-finding.md`
3. Add appropriate frontmatter
4. Open the file in your default editor
5. Commit and push the change if the TIL directory is a git repository

## Configuration

The tool can be configured with environment variables:

| Environment Variable | Description                   | Default     |
| -------------------- | ----------------------------- | ----------- |
| `TIL_FOLDER`         | Location to store TIL entries | `$HOME/til` |
| `TIL_TEMPLATE`       | Custom template string        | See below   |
| `TIL_TAGS`           | Default tags for entries      | Empty       |
| `TIL_SKIP_PUSH`      | Skip git commit and push      | `false`     |

### Default Template

```markdown
---
title: { TITLE }
date: { DATE }
tags: { TAGS }
---

# {TITLE}

{CONTENT}
```

## Command Line Options

```
Usage: til [OPTIONS] "TITLE"

Create a Today I Learned (TIL) markdown entry with the given title.
Note: Multi-word titles must be enclosed in quotes.

Options:
  -h, --help                   Show this help message and exit
  -d, --directory DIR          Specify the TIL directory
  -T, --template FILE          Use a custom template file
  -t, --tags TAGS              Provide tags for the TIL file
  --skip-push                  Skip git commit and push
```

## Examples

```bash
# Basic usage
til "Bash Parameter Expansion"

# With specific tags
til -t "bash,scripting" "Bash Parameter Expansion"

# Using a different directory
til -d ~/documents/til "Vim Visual Mode"

# Using a custom template
til -T ~/templates/custom.md "Docker Compose Networks"

# Skip the git commit and push
til --skip-push "Quick Local Note"
```

## Development

### Running Tests

Tests are written using the [Bats](https://github.com/bats-core/bats-core) testing framework:

```bash
# Install Bats if needed
git clone https://github.com/bats-core/bats-core.git
git clone https://github.com/bats-core/bats-support.git test/test_helper/bats-support
git clone https://github.com/bats-core/bats-assert.git test/test_helper/bats-assert

# Run tests
bats test/til.bats
```

## License

MIT License
