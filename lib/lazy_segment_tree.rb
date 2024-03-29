class LazySegmentTree
  # define below
  def id; 0; end
  def e; [0, 0, 0]; end

  def mapping(a, x)
    return a if x.zero?
    a0, a1, at = a
    a[0] = a1; a[1] = a0; a[2] = a1 * a0 - at
    return a
  end

  def composite(x, y, out = nil)
    x ^ y
  end

  def op(a, b, out = nil)
    a0, a1, at = a
    b0, b1, bt = b
    out[0] = a0 + b0; out[1] = a1 + b1; out[2] = at + bt + a1 * b0
    out
  end
  
  # customize here at initialize from Array.

  class << self
    def from(seq); new(seq.size).build(seq); end
  end
  
  def build(seq)
    seq.each_with_index{|a, i| @node[@offset + i] = a }
    i = @offset
    merge(i) while (i -= 1) > 0
    self
  end
  
  # Templates  
  attr_reader :commutative_operator
  def initialize(n)
    @offset = 1 << (n - 1).bit_length
    @node = Array.new(@offset << 1){ e }
    @cmd = Array.new(@offset << 1){ id }
    @commutative_operator = true
  end
  

  def apply(k, x = id)
    x = composite(x, @cmd[k], x)
    @cmd[k] = id
    @node[k] = mapping(@node[k], x)
    return @node[k] if k >= @offset
    
    @cmd[2 * k] = composite(x, @cmd[2 * k], @cmd[2 * k])
    @cmd[2 * k + 1] = composite(x, @cmd[2 * k + 1], @cmd[2 * k + 1])
    return @node[k]
  end
  
  def merge(k)
    @node[k] = apply(k)
    return @node[k] if k >= @offset
    @node[k] = op(apply(2 * k), apply(2 * k + 1), @node[k])
    return @node[k]
  end

  def revalidates(l, r)
    return [1] if r - l == @offset
    a = l / (l & -l); b = r / (r & -r)
    g = []
    while l < r
      g << r if r < b
      g << l if l < a
      l >>= 1; r >>= 1
    end
    while l > 0
      g << l
      l >>= 1
    end
    g
  end

  def sum(l, r)
    l += @offset
    r += @offset

    g = revalidates(l, r)
    g.reverse_each{|k| apply(k) }
    
    lx = e; rx = e
    while l < r
      (lx = op(lx, apply(l), lx) and l += 1) if l.odd?
      (r -= 1 and rx = op(apply(r), rx, rx)) if r.odd?
      l >>= 1; r >>= 1
    end
    return op(lx, rx, lx)
  end

  def add(l, r, x)
    l += @offset
    r += @offset
    g = revalidates(l, r)

    g.reverse_each{|k| apply(k) } if !@commutative_operator
    while l < r
      (apply(l, x) and l += 1) if l.odd?
      (r -= 1 and apply(r, x)) if r.odd?
      l >>= 1; r >>= 1
    end
    g.each{|k| merge(k) }
  end
end

N, Q = gets.split.map(&:to_i)
A = gets.split.map(&:to_i)
lz = LazySegmentTree.from(A.map{|a| [1 - a, a, 0] })
ans = []
Q.times do
  t, l, r = gets.split.map(&:to_i)
  if t == 1
    lz.add(l - 1, r, 1)
  else
    ans << lz.sum(l - 1, r)[2]
  end
end
puts ans
