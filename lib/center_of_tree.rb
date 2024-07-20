def center_of_tree(t, s = 0)
  h = t.size / 2
  c = nil
  dfs = ->(u, up){
    sum = 1
    max = 0
    t[u].each do |v|
      next if v == up
      z = dfs[v, u]
      max = z if z > max
      sum += z
    end
    z = t.size - sum
    max = z if z > max
    c = u if max <= h
    sum
  }
  dfs[s, s]
  return c
end

# return 1
puts center_of_tree([[1],[0,2],[1]])
