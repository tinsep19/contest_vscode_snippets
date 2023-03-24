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
SNIPPETS_PATH=$HOME/.config/Code/User/snippets/ruby.json

add_snippet "UnionFind" "_@ union_find" "src/union_find.rb"
add_snippet "SPFA" "_@ spfa" "src/spfa.rb"
add_snippet "C[n,r]" "_@ mod_comb" "src/mod_comb.rb"
add_snippet "Graph" "_@ graph" "src/graph.rb"
add_snippet "FenwickTree" "_@ fenwick_tree" "src/fenwick_tree.rb"
add_snippet "Dijkstra" "_@ dijkstra" "src/dijkstra.rb"
add_snippet "Flow" "_@ flow" "src/flow.rb"
add_snippet "yes!;no!" "_@ yesno" "src/yesno.rb"

merge_snippets | tee "$SNIPPETS_PATH"
