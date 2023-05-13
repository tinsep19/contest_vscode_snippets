# スライド最小値/最大値
# min = SlideWindow.new(w, &:<)
# max = SLideWindow.new(w, &:>)
# 広義単調増加判定 : min = SlideWindow.new(w, &:<), min.size == w
# 狭義単調増加判定 : min = SlideWindow.new(w, &:<=), min.size == w
class SlideWindow
  Node = Struct.new(:value, :t)
  def initialize(w, &cmp)
    @window = w
    @q = []
    @cmp = cmp
  end
  def push(v, t)
    @q.shift while @q.size > 0 && @q[0].t + @window <= t
    @q.pop while @q.size > 0 && @cmp.call(v, @q[-1].value)
    @q.push(Node.new(v, t))
  end
  def peak
    @q.empty? ? nil : @q[0].value
  end
  def peaked_at
    @q.empty? ? nil : @q[0].t
  end
  alias_method :peek, :peak 
  alias_method :peeked_at, :peaked_at
  def size; @q.size; end
end
