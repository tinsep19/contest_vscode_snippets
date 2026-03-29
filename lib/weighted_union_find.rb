class WeightedUnionFind
  def initialize(n)
    @g = Array.new(n, -1)
    @w = Array.new(n, 0)
    @components = n
  end
  attr_reader :components
  def count(i); -@g[leader(i)]; end
  def connect?; @components == 1; end
  def weight(i); leader(i); @w[i]; end
  def groups; @g.size.times.group_by{leader(_1)}.values; end
  def diff(x, y);  weight(y) -  weight(x); end
  def same?(i, j); leader(i) == leader(j); end
  def leader(i)
    r = j = i
    sum = 0
    until (j = @g[r]) < 0
      sum += @w[r]
      r = j
    end

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
    x, y, i, j, w = y, x, j, i, -w if -@g[x] < -@g[y]
    
    if x == y
      raise "#{i} and #{j} were already merged and inconsistent ." if diff(i, j) != w
      return
    end
    
    @g[x] += @g[y]
    @g[y] = x
    @w[y] = @w[i] - @w[j] + w
    @components -= 1
    x
  end
  
  def add
    @g << -1
    @w << 0
    @components += 1
    @g.size - 1
  end
end
