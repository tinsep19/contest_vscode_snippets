class FenwickTree
  class << self
    def from(a)
      bit = new(a.size)
      i = a.size
      bit.add(i, a[i]) while (i -= 1) >= 0
      bit
    end
  end
  def initialize(n)
    @size = n
    @data = Array.new(1 << (n + 1).bit_length, 0)
  end
  def add(i, x)
    raise if i >= @size
    i += 1
    while i < @data.size
      @data[i] += x
      i += (i & -i)
    end
  end
  # sum of [0, i)
  # return 0 if i == 0
  def prefix(i)
    s = 0
    while i > 0
      s += @data[i]
      i -= (i & -i)
    end
    s
  end
  # sum of [l, r)
  def sum(l,r)
    prefix(r) - prefix(l)
  end
  # usage bit.bsearch_index{|s| s >= x }
  # return min-index r satisfy sum of [0, r] >= x
  #
  # Caution) returned index is included end.
  # r = bit.sum{|s| s >= x }
  # bit.sum(0, r) < x
  # bit.sum(0, r + 1) >= x
  def bsearch_index(&block)
    pos = 0
    len = @data.size
    s = 0
    while (len >>= 1) > 0
      if !block.call(s + @data[pos + len])
        pos += len
        s += @data[pos]
      end
    end
    pos < @size ? pos : nil
  end
end
BIT = FenwickTree

def range_add_sum(n)
  bit1 = FenwickTree.new(n)
  bit2 = FenwickTree.new(n)
  add = ->(l, r, x) {
    bit1.add(l,  x)
    bit1.add(r, -x)
    bit2.add(l,  x * l)
    bit2.add(r, -x * r)
  }
  sum = ->(l, r) {
    r * bit1.prefix(r) - l * bit1.prefix(l) - (bit2.prefix(r) - bit2.prefix(l))
  }
  [add, sum]
end
