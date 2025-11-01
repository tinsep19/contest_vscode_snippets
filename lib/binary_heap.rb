class BinaryHeap
  def initialize(&block)
    @heap = []
    instance_exec(&block) if block_given?
    raise "you must have _higher?" unless respond_to? :_higher?
  end

  def empty?; @heap.empty?; end
  def size; @heap.size; end
  def top; @heap[0]; end
  def pop; el = @heap.pop; @heap.empty? ? el : replace_top(el); end
  def replace_top(el); @heap[0], x = el, @heap[0]; _down!(0); x; end
  def push(x); @heap << x; _up!(@heap.size - 1); end
  def inspect;"#<PQ: @heap = #{@heap}>"; end
  alias_method :to_s, :inspect
  alias_method :<<, :push

  private
  def _up!(i)
    h = @heap
    x = h[i]
    while i > 0
      up = (i - 1) >> 1
      break if _higher?(h[up], x)
      h[i] = h[up]
      i = up
    end
    h[i] = x
  end

  def _down!(up)
    h = @heap
    x = h[up]
    n = h.size
    while (j = 2 * up + 1) < n
      j += 1 if j + 1 < n && _higher?(h[j + 1], h[j])
      y = h[j]
      break if _higher?(x, y)
      h[up] = y
      up = j
    end
    h[up] = x
  end

end
PQ = BinaryHeap
# comment in, below
#
# pq = PQ.new do
#   def _higher?(actual, other)
#     actual < other
#   end
# end
