class LazySegmentTree
  # LazySegmentTree.new(Node, n){|i, node| ... }
  def initialize(node_class, n, &block)
    @commutative = false
    @node_class = node_class
    verify_node_class!
    @size = n
    @offset = (1 << (n - 1).bit_length)
    @node = Array.new(@offset << 1){ node_class.new }
    n.times{|i| block[i, @node[@offset + i]] } if block
    k = @offset
    merge(k) while (k -= 1) > 0
  end

  # When @commutative is true, #apply (l,r,x) does not propagate @act values.
  # Advance when composition(f, g) is commutative.
  # default: false
  attr_accessor :commutative
  
  def prod(l, r)
    l += @offset
    r += @offset
    g = adaptive_group(l, r)

    lx = @node_class.new
    rx = @node_class.new
    g.reverse_each{|k| propagate(k) }
    while l < r
      (lx.merge!(lx, @node[l]); l += 1) if l.odd?
      (r -= 1; rx.merge!(@node[r], rx)) if r.odd?
      l >>= 1; r >>= 1
    end
    lx.merge!(lx, rx)
    lx
  end

  def apply(l, r, x)
    l += @offset
    r += @offset
    g = adaptive_group(l, r)

    g.reverse_each{|k| propagate(k) } unless @commutative
    while l < r
      (propagate(l, x); l += 1) if l.odd?
      (r -= 1; propagate(r, x)) if r.odd?
      l >>= 1; r >>= 1
    end
    g.each{|k| merge(k) }
  end

  private
  def verify_node_class!
    require_methods = [:merge!, :composite!, :map!, :act]
    require_methods.reject!{|sym| @node_class.method_defined?(sym) }
    raise "#{require_methods} was not defined." if require_methods.size > 0
  end
  
  def propagate(k, x = nil)
    current = @node[k]
    current.composite!(x) if x
    f = current.act
    if k < @offset
      @node[2 * k].composite!(f)
      @node[2 * k + 1].composite!(f)
    end
    current.map!
  end
  
  def merge(k)
    @node[k].merge!(@node[2 * k], @node[2 * k + 1])
  end

  def adaptive_group(l, r)
    a = l / (l & -l)
    b = r / (r & -r)
    g = []
    while l > 0 && l < r
      g << r if r < b
      g << l if l < a
      l >>= 1; r >>= 1
    end
    (g << l; l >>= 1) while l > 0
    g
  end
end
