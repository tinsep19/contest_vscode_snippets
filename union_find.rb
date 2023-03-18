class UnionFind
  def initialize(n)
    @group_size = n
    @g = Array.new(n, -1)
    @e = Array.new(n, 0)
  end

  def add_node
    @group_size += 1
    @e << 0
    @g << -1
    @g.size - 1
  end

  def leader(i)
    r = j = i
    r = j while (j = @g[r]) >= 0
    @g[j] = r while (i = @g[j = i]) >= 0
    r
  end

  def merge(a,b)
    x, y = leader(a), leader(b)
    x, y = y, x if -@g[x] < -@g[y]
    @e[x] += 1
    if x != y
      @group_size -= 1
      @g[x] += @g[y]
      @g[y] = x
    end
  end

  attr_reader :group_size
  def size; @g.size; end
  def same?(a,b); leader(a) == leader(b); end
  def count_node(i); -@g[leader(i)]; end
  def count_edge(i); @e[leader(i)]; end

  def groups; size.times.group_by{ leader(_1) }.values; end
  def leaders; size.times.select{ @g[_1] < 0}; end

  def tree?(i); count_node(i) == count_edge(i) + 1; end
  def forest?; leaders.all?{|i| tree?(i) }; end

  alias_method :count, :count_node
  alias_method :root, :leader
  alias_method :find, :leader
  alias_method :unite, :merge
end
