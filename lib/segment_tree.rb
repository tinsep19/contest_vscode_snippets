class SegmentTree
  def initialize(n, &block)
    instance_exec(&block) if block_given?
    @offset = 1 << (n - 1).bit_length
    @data = Array.new(@offset << 1, e)
  end
  
  def build(seq)
    seq.each_with_index{|x,i|@data[@offset + i] = x }
    i = @offset
    @data[i] = merge(@data[2 * i], @data[2 * i + 1]) while (i -= 1) > 0
    self
  end

  def add(i, x)
    i += @offset
    @data[i] += x
    @data[i] = merge(@data[2 * i], @data[2 * i + 1]) while (i >>= 1) > 0
  end

  def update(i, x)
    i += @offset
    @data[i] = x
    @data[i] = merge(@data[2 * i], @data[2 * i + 1]) while (i >>= 1) > 0
  end

  def query(l, r)
    l += @offset
    r += @offset
    x = e
    while l < r
      x = merge(x, @data[l]) and l += 1 if l.odd?
      r -= 1 and x = merge(x, @data[r]) if r.odd?
      l >>= 1; r >>= 1;
    end
    return x
  end
  class << self
    def from(seq, &block)
      n = seq.size
      new(n, &block).build(seq)
    end
    def min(n)
      new(n) do
        def e; Float::INFINITY; end
        def merge(a,b); a < b ? a : b; end
      end
    end
    def max(n)
      new(n) do
        def e; -Float::INFINITY; end
        def merge(a,b); a > b ? a : b; end
      end
    end
    def sum(n)
      new(n) do
        def e; 0; end
        def merge(a,b); a + b; end
      end
    end
  end
end
