class UnionFind
  def initialize(n)
    @g = Array.new(n, -1)
    @components = n
  end
  def add
    @g << -1
    @components += 1
    @g.size - 1
  end
  def leader(i)
    r = j = i
    r = j until (j = @g[r]) < 0
    @g[i] = r and i = j until (j = @g[i]) < 0
    r
  end
  def same?(i, j)
    leader(i) == leader(j)
  end
  def merge(i,j)
    x, y = leader(i), leader(j)
    return false if x == y
    x, y = y, x if -@g[x] < -@g[y]
    @g[x] += @g[y]
    @g[y] = x
    @components -= 1
  end
  def count(i)
    -@g[leader(i)]
  end
  def groups
    size.times.group_by{|i| leader(i) }.values
  end
  def size
    @g.size
  end
  attr_reader :components
  def connect?
    @components == 1
  end
end
