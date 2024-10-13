require 'numo/narray'
class WarshallFroyd
  INF = 1 << 60
  def initialize(n)
    @g = Numo::Int64.new(n, n).fill(INF)
    @g.diagonal.store(0)
    @size = n
  end
  def [](a,b)
    @g[a, b]
  end
  def add_edge(a, b, w)
    @g[a, b] = w
    @g[b, a] = w
  end
  def optimize!
    @size.times do |k|  
      ik = @g[true, k].expand_dims(0).transpose
      kj = @g[k, true]
      @g = Numo::Int64.minimum(@g, ik + kj)
    end
  end
  def update!(a, b, w)
    return if @g[a,b] <= w
    @g[a, b] = w
    @g[b, a] = w

    ia = @g[true, a].expand_dims(0).transpose
    bj = @g[b, true]
    @g = Numo::Int64.minimum(@g, ia + bj + w)

    ib = @g[true, b].expand_dims(0).transpose
    aj = @g[a, true]
    @g = Numo::Int64.minimum(@g, ib + aj + w)
  end
end
