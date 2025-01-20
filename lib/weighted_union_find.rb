class WeightedUnionFind
  def initialize(n)
    @g = Array.new(n, -1)
    @w = Array.new(n, 0)
    @components = n
  end
  def add
    @g << -1
    @w << 0
    @components += 1
    @g.size - 1
  end
  def count(i); -@g[leader(i)]; end
  attr_reader :components
  def connect?; @components == 1; end

  def weight(i); leader(i); @w[i]; end
  alias_method :potensial, :weight

  def diff(x, y); weight(y) - weight(x); end
  def same?(i, j); leader(i) == leader(j); end
  def leader(i)
    r = j = i
    sum = 0
    sum += @w[r] and r = j until (j = @g[r]) < 0
    j = i
    until (j = @g[i]) < 0
      sum -= @w[i]
      @w[i] += sum
      @g[i] = r
      i = j
    end
    r
  end
  # i -> j : w
  def merge(i, j, w = 0)
    x, y = leader(i), leader(j)
    x, y, i, j, w = y, x, j, i, -w if @g[x] < @g[y]
    
    raise "#{i} and #{j} were already merged and inconsistent ." if x == y && diff(i, j) != w
    
    @g[x] += @g[y]
    @g[y] = x
    @w[y] = @w[i] - @w[j] + w
    @components -= 1
  end
  def groups; @g.size.times.group_by{leader(_1)}.values; end
end
