#!/bin/bash

function snippet_entry() {
  local key=$1
  local prefix=$2
  local file=$3

  local body=$(jq '.' "$file" -R | jq -s '.')

  local args=()
  args+=(--arg name "$key")
  args+=(--arg prefix "$prefix")

  local filter='{ key: $name, value: {prefix: $prefix, body: . }}'

  jq "${args[@]}" "$filter" <<<"$body"
}

function add_snippet(){
  local key=$1
  local prefix=$2
  local file=$3
  local entry=$(snippet_entry "$key" "$prefix" "$file")
  snippets+=("$entry")
}

function merge_snippets(){
  jq 'from_entries' -s <<<"${snippets[*]}"  
}

snippets=()
SNIPPETS_DIR="$(cd $(dirname $0); pwd)/../lib"

VSCODE_SNIPPETS_PATH=$HOME/.config/Code/User/snippets/ruby.json
HELIX_SNIPPETS_PATH=$HOME/.config/helix/snippets/ruby.json
for f in $SNIPPETS_DIR/*.rb; do
  add_snippet "$(basename $f)" "$(basename $f)" "$f"
done

merge_snippets | tee "$VSCODE_SNIPPETS_PATH" "$HELIX_SNIPPETS_PATH"
