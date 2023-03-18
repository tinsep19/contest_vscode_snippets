#!/bin/bash

function snippet_entry() {
  NAME=$1
  PREFIX=$2
  FILE=$3

  BODY=$(jq '.' "$FILE" -R | jq -s '.')
  jq '{ key: $name, value: {prefix: $prefix, body: . }}' --arg name "$NAME" --arg prefix "$PREFIX" <<<$BODY
}

snippets=()
snippets+=("$(snippet_entry "UnionFind" "@@_ union_find" "union_find.rb")")
snippets+=("$(snippet_entry "SPFA" "@@_ spfa" "spfa.rb")")
snippets+=("$(snippet_entry "C[n,r]" "@@_ mod_comb" "mod_comb.rb")")
snippets+=("$(snippet_entry "Graph" "@@_ graph" "graph.rb")")
snippets+=("$(snippet_entry "FenwickTree" "@@_ fenwick_tree" "fenwick_tree.rb")")
snippets+=("$(snippet_entry "Dijkstra" "@@_ dijkstra" "dijkstra.rb")")
snippets+=("$(snippet_entry "Flow" "@@_ flow" "flow.rb")")
snippets+=("$(snippet_entry "yes!;no!" "@@_ yesno" "yesno.rb")")

SNIPPETS_PATH="$HOME/.config/Code/User/snippets/ruby.json"
jq 'from_entries' -s <<<"${snippets[*]}" | tee "$SNIPPETS_PATH"
