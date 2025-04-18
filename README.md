<div align="center">

# TIL Tool

A simple bash script to quickly create "Today I Learned" notes from the command line.

![image](https://github.com/user-attachments/assets/8fa4c5e4-7fc0-4586-b2d2-e07670c81d3d)

</div>

## Features

- ✨ Create TIL notes with a single command.
- 📝 Customize! Content, location, tags...
- 🔄 Git integration for automatic commits and pushes

## Usage

Download the `til` to some location on your `$PATH`:

```bash
# Download this script and make it executable
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/hschne//refs/heads/main/til > ~/.local/bin/til && chmod +x ~/.local/bin/til
```

Then, create a new TIL note:

```bash
til "Using fzf for Fuzzy Finding"
```

This will automatically create a new markdown file with today's date (`YYYY-MM-DD-using-fzf-for-fuzzy-finding.md`) and open it in your preferred editor. Once you save and close the editor your file will be automatically committed and pushed (if your TIL folder is a git repository).

To learn how you can customize your TIL notes content and note location see [#Configuration].

## Configuration

The tool can be configured with environment variables:

| Environment Variable | Description                   | Default     |
| -------------------- | ----------------------------- | ----------- |
| `TIL_FOLDER`         | Location to store TIL entries | `$HOME/til` |
| `TIL_TEMPLATE`       | Custom template string        | See below   |
| `TIL_TAGS`           | Default tags for entries      | Empty       |
| `TIL_SKIP_PUSH`      | Skip git commit and push      | `false`     |

It also provides the following command line options.

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

You will want to use a custom TIL folder and potentially a custom template. We recommend you use an alias and overwrite environment variables accordingly.

```bash
# ~/.aliases
alias til="til -d ~/code/my-til-repository/notes -T ~/code/my-til-repository/template.md"

```

### Templates

You may use a custom template file to structure you TIL notes. Templates may contain placeholders. The default template below lists available placeholders.

```markdown
---
title: { TITLE }
date: { DATE }
tags: { TAGS }
---

# {TITLE}

{CONTENT}
```

## Advanced Usage

```bash
# Simple use case
til "Bash Parameter Expansion"
# Read from stdin. Great for scripting.
somecommand | til "My Automated TIL"
# Customize using env vars
export TIL_FOLDER=~/code/my-til-repository/notes
export TIL_TEMPLATE=$(cat ~/code/my-til-repository/template.md)
til "Bash Parameter Expansion"
```

## Credit

TIL ("Today I Learned") notes are brief documents that record new snippets of knowledge you acquire daily. This tool is inspired by repositories like [jbranchaud/til](https://github.com/jbranchaud/til) and [thoughtbot/til](https://github.com/thoughtbot/til) and aims to make it easier for anyone to start their own TIL repository.

Shoutout also to [Chris Oliver] & Andrew Mason who discussed TIL notes in [this episode of Remote Ruby](https://www.remoteruby.com/2260490/episodes/16891112-more-listener-questions) and motivated the creation of this script.

## Development

### Running Tests

Tests are written using the [Bats](https://github.com/bats-core/bats-core) testing framework. Install bats if needed and run tests.

```bash
bats test/til.bats
```

## License

MIT License
