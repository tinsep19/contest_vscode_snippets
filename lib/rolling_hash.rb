# Usage. 
# param = RollingHash.params(x, mod) # mod is prime, x < m
# cs = param.cumsum([1, 2, 3, 4, 5]) # seq is static
# st = param.segment_tree([1, 2, 3, 4, 5]) # seq is dynamic. 
# puts cs[1,4] # show hash [2,3,4]
# puts st[1,4] # show hash [2,3,4]
# st[1] = 3 # update. [1, 3, 3, 4, 5]
# puts st[1,4] # show hash [3,3,4]

module RollingHash
  class << self
    def param(x = 998244353, m = 10 ** 9 + 7); Param.new(x, m); end
  end
  class Param
    attr_reader :x, :mod, :pow
    def initialize(x,m)
      @x = x; @mod = m; @pow = [1]
    end
    def cumsum(seq)
      _prepare(seq.size)
      Cumsum.new(seq, self)
    end
    def segment_tree(seq)
      _prepare(seq.size)
      SegmentTree.new(seq, self)
    end
    # join(hash1, size1, hash2, [size2, hash3, size3, ...] )
    # H(S + T) = H(S) + H(T) * x ^ |S|
    def join(*hz)
      x, offset = 0, 0
      hz.each_slice(2) do |hash, size|
        _prepare(offset)
        x = (x + hash * @pow[offset]) % @mod
        return x if !size
        offset = (offset + size) % (@mod - 2)
      end
      return x
    end
    private
    def _prepare(z)
      @pow << @pow[-1] * @x % @mod until @pow.size > z
    end
  end
  class SegmentTree
    def initialize(seq, param)
      @size = seq.size
      @param = param
      @pow = @param.pow
      @mod = @param.mod
      @offset_inv = @pow[@size].pow(@mod - 2, @mod)
      @offset = (1 << (@size - 1).bit_length)
      @data = Array.new(@offset << 1, 0)
      build!(seq)
    end
    def build!(seq)
      seq.each_with_index{|x,i| @data[@offset + i] = x * @pow[i] % @mod }
      i = @offset
      @data[i] = (@data[2 * i] + @data[2 * i + 1]) % @mod while (i -= 1) > 0
    end
    def update(i, x)
      k = @offset + i
      @data[k] = x * @pow[i]
      @data[k] = (@data[2 * k] + @data[2 * k + 1]) % @mod while (k >>= 1) > 0
    end
    alias_method :[]=, :update
    def query(l, r)
      i = l
      l += @offset
      r += @offset
      x = 0
      while l < r
        x = (x + @data[l]) % @mod and l += 1 if l.odd?
        r -= 1 and x = (x + @data[r]) % @mod if r.odd?
        l >>= 1; r >>= 1
      end
      x * @pow[@size - i] % @mod * @offset_inv % @mod
    end
    alias_method :[], :query
  end
  class Cumsum
    def initialize(seq, param)
      @param = param
      @mod = @param.mod
      @pow = @param.pow
      @size = seq.size
      @offset_inv = @pow[@size].pow(@mod - 2, @mod)
      @sum = Array.new(seq.size + 1, 0)
      seq.each_with_index{|x,i|@sum[i + 1] = (@sum[i] + x * @pow[i]) % @mod }
    end
    def [](l,r); (@sum[r] - @sum[l]) * @pow[@size - l] % @mod * @offset_inv % @mod; end
  end
end
