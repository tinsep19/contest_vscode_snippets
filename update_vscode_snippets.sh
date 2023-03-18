#!/bin/bash

function snippet_entry() {
  local key=$1
  local prefix=$2
  local file=$3

  local body=$(jq '.' "$file" -R | jq -s '.')
  local args=()
  args+=(--arg name "$key")
  args+=(--arg prefix "$prefix")

  jq "${args[@]}" '{ key: $name, value: {prefix: $prefix, body: . }}' <<<$body
}

function add_snippet(){
  local key=$1
  local prefix=$2
  local file=$3
  snippets+=("$(snippet_entry "$key" "$prefix" "$file")")
}

SNIPPETS_PATH="$HOME/.config/Code/User/snippets/ruby.json"
snippets=()

add_snippet "UnionFind" "@@_ union_find" "union_find.rb"
add_snippet "SPFA" "@@_ spfa" "spfa.rb"
add_snippet "C[n,r]" "@@_ mod_comb" "mod_comb.rb"
add_snippet "Graph" "@@_ graph" "graph.rb"
add_snippet "FenwickTree" "@@_ fenwick_tree" "fenwick_tree.rb"
add_snippet "Dijkstra" "@@_ dijkstra" "dijkstra.rb"
add_snippet "Flow" "@@_ flow" "flow.rb"
add_snippet "yes!;no!" "@@_ yesno" "yesno.rb"

jq 'from_entries' -s <<<"${snippets[*]}" | tee "$SNIPPETS_PATH"
