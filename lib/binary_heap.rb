class BinaryHeap
  def initialize; @heap = []; end
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
  def _higher?(actual, other); actual > other; end

  def _up!(i)
    x = @heap[i]
    while i > 0
      up = (i - 1) >> 1
      break if _higher?(@heap[up], x)
      @heap[i] = @heap[up]
      i = up
    end
    @heap[i] = x
  end

  def _down!(up)
    x = @heap[up]
    n = @heap.size
    while (j = 2 * up + 1) < n
      j += 1 if j + 1 < n && _higher?(@heap[j + 1], @heap[j])
      break if _higher?(x, @heap[j])
      @heap[up] = @heap[j]
      up = j
    end
    @heap[up] = x
  end

end
PQ = BinaryHeap

