class Integer
  def isqrt
    x = self
    y = Integer.sqrt(x) + 1
    y -= 1 while y * y > x
    y
  end
  def rtimes; i = self; yield i while (i -= 1) >= 0; end
  def popcount
    x_ = self;
    x_ = (x_ & 0x55555555) + (x_>> 1 & 0x55555555)
    x_ = (x_ & 0x33333333) + (x_>> 2 & 0x33333333)
    x_ = (x_ & 0x0f0f0f0f) + (x_>> 4 & 0x0f0f0f0f)
    x_ = (x_ & 0x00ff00ff) + (x_>> 8 & 0x00ff00ff)
    x_ = (x_ & 0x0000ffff) + (x_>>16 & 0x0000ffff)
  end
end
class Array
  def chmin(i, x); self[i] = x if x < self[i]; end
  def chmax(i, x); self[i] = x if x > self[i]; end
  def cumsum0
    sum = Array.new(size + 1, 0)
    size.times{|i| sum[i + 1] = sum[i] + self[i] }
    sum
  end
  def rcumsum0
    sum = Array.new(size + 1, 0)
    size.rtimes{|i| sum[i] = sum[i + 1] + self[i] }
    sum
  end
end
def _min(a,b); a < b ? a : b; end
def _max(a,b); a > b ? a : b; end
def ans!(n); puts n; exit; end
def yes!; puts :Yes; exit; end
def no!; puts :No; exit; end
def yesno!(b); puts b ? :Yes : :No; exit; end
def yesno(b); b ? :Yes : :No; end

