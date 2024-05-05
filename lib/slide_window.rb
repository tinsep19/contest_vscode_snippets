# スライド最小値/最大値
# min = SlideWindow.new(w, &:<)
# max = SLideWindow.new(w, &:>)
# 広義単調増加判定 : min = SlideWindow.new(w, &:<), min.size == w
# 狭義単調増加判定 : min = SlideWindow.new(w, &:<=), min.size == w
class SlideWindow
  def initialize(w, &cmp)
    @window = w
    @events = []
    @values = []
    @cmp = cmp
  end
  def push(v, t)
    (@events.shift; @values.shift) until @events.empty? || t - @events[0] < @window
    (@events.pop; @values.pop) until @values.empty? || @cmp.call(@values[-1], v)
    @values << v ; @events << t
  end
  def peak; @values[0]; end
  def peaked_at; @events[0]; end
  alias_method :peek, :peak 
  alias_method :peeked_at, :peaked_at
  def size; @events.size; end
end
