class Integer
  def popcount
    x_ = self;
    x_ = (x_ & 0x55555555) + (x_>>1 & 0x55555555);
    x_ = (x_ & 0x33333333) + (x_>>2 & 0x33333333);
    x_ = (x_ & 0x0f0f0f0f) + (x_>>4 & 0x0f0f0f0f);
    x_ = (x_ & 0x00ff00ff) + (x_>>8 & 0x00ff00ff);
    x_ = (x_ & 0x0000ffff) + (x_>>16 & 0x0000ffff);
    return x_;      
  end
end
def prepare_popcount(n)
  dp = Array.new(1 << n)
  i = 0; dp[0] = 0
  dp[i] = dp[i - (i & -i)] + 1 while (i += 1) < dp.size
  dp
end
