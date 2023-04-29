class UnionFind
  def initialize(n)
    @g = Array.new(n, -1)
  end
  def leader(i)
    @g[i] >= 0 ? @g[i] = leader(@g[i]) : i
  end
  def merge(a,b)
    x, y = leader(a), leader(b)
    return if x == y
    x, y = y, x if -@g[x] < -@g[y]
    @g[x] += @g[y]
    @g[y] = x
  end
  def count(i); -@g[leader(i)]; end
  def size; @g.size; end
  def same?(a,b); leader(a) == leader(b); end
  def groups; size.times.group_by{ leader(_1) }.values; end
  def leaders; size.times.select{ @g[_1] < 0}; end
end
