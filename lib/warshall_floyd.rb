require 'numo/narray'
INF = 1 << 30
N, M = gets.split.map(&:to_i)
g = Numo::Int64.new(N, N).fill(INF)
g.diagonal.store(0)
M.times do
  a,b,c = gets.split.map(&:to_i)
  a -= 1; b -= 1
  st[a, b] = c
end
sum = 0

N.times do |k|  
  ik = g[true, k].expand_dims(0).transpose
  kj = g[k, true]
  g = Numo::Int64.minimum(g, ik + kj)
end
puts sum