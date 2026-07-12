# スライド最小値/最大値
class SlideWindow
  class << self
    def max; new{|a,b| a > b }; end
    def min; new{|a,b| a < b }; end
  end
  def initialize(&block)
    @events = []
    @cmp = block
  end
  def top; @events.empty? ? nil : @events[0][0]; end
  # add event (x, t)
  def push(x, t)
    @events.pop until @events.empty? || @cmp[@events[-1][0], x]
    @events << [x, t]
  end
  # delete events before t.
  def expire(t)
    @events.shift until @events.empty? || @events[0][1] > t
  end
  def size; @events.size; end
end
