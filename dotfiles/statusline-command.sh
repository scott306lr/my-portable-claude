#!/bin/bash
# Claude Code statusLine: dir | git branch | model | ctx%
# A minimal example — edit freely; changes sync like any dotfile.

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

dir=$(basename "${cwd:-$(pwd)}")

branch=""
if git -C "${cwd:-.}" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "${cwd:-.}" symbolic-ref --short HEAD 2>/dev/null ||
           git -C "${cwd:-.}" rev-parse --short HEAD 2>/dev/null)
fi

out="$dir"
[ -n "$branch" ] && out+=" on $branch"
[ -n "$model" ] && out+=" | $model"
[ -n "$used_pct" ] && out+=" | ctx ${used_pct%%.*}%"

printf '%s' "$out"
