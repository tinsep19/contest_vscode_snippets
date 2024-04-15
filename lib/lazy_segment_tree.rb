# Usage
# 1. Define Node.
#    require methods: :map!, :merge!, :composite!, :act, constructor without parameter.
# 2. lz = LazySegmentTree.new(Node, n){|i, node| ... }
# 3. lz.update(l, r, x)
# 4. lz.query(l, r)
# 
class LazySegmentTree
  
  def initialize(node_class, n, &block)
    @node_class = node_class
    verify_node_class!
    @size = n
    @offset = (1 << n.bit_length)
    @node = Array.new(@offset << 1){ node_class.new }
    n.times{|i| block[i, @node[@offset + i]] } if block
    k = @offset
    merge(k) while (k -= 1) > 0
  end
  
  def verify_node_class!
    require_methods = [:merge!, :composite!, :map!, :act]
    require_methods.reject!{|sym| @node_class.method_defined?(sym) }
    raise "#{require_methods} was not defined." if require_methods.size > 0
  end
  
  def apply(k, x = nil)
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

  def g_index(l, r)
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
  
  def query(l, r)
    l += @offset
    r += @offset
    g = g_index(l, r)

    lx = @node_class.new
    rx = @node_class.new
    g.reverse_each{|k| apply(k) }
    while l < r
      (lx.merge!(lx, @node[l]); l += 1) if l.odd?
      (r -= 1; rx.merge!(@node[r], rx)) if r.odd?
      l >>= 1; r >>= 1
    end
    lx.merge!(lx, rx)
    lx
  end
  
  def update(l, r, x)
    l += @offset
    r += @offset
    g = g_index(l, r)

    g.reverse_each{|k| apply(k) }
    while l < r
      (apply(l, x); l += 1) if l.odd?
      (r -= 1; apply(r, x)) if r.odd?
      l >>= 1; r >>= 1
    end
    g.each{|k| merge(k) }
  end
end

