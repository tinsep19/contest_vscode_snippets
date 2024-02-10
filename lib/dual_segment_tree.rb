class DualSegTree
  def initialize(seq)
    n = seq.size
    @offset = 1 << (n - 1).bit_length
    @data = Array.new(@offset << 1, 0)
    seq.each_with_index{|x,i| @data[@offset + i] = x }
  end

  def update(l, r, x)
    l += @offset
    r += @offset
    while l < r
      @data[l] = merge(@data[l], x) and l += 1 if l.odd?
      r -= 1 and @data[r] = merge(@data[r], x) if r.odd?
      l >>= 1; r >>= 1
    end
  end

  def [](i)
    i += @offset
    x = e
    x = merge(x, @data[i]) and i >>= 1 while i > 0
    return x
  end

  # sum
  def e; 0; end
  def merge(a,b); a + b; end

  # max
  # def e; -Float::INFINITY ; end
  # def merge(a,b); a > b ? a : b; end

  # min
  # def e; Float::INFINITY; end
  # def merge(a,b); a < b ? a : b; end
  
end
