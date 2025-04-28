class Integer
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
end
def _min(a,b); a < b ? a : b; end
def _max(a,b); a > b ? a : b; end
def ans!(n); puts n; exit; end
def yes!; puts :Yes; exit; end
def no!; puts :No; exit; end
def yesno!(b); puts b ? :Yes : :No; exit; end
def yesno(b); b ? :Yes : :No; end
