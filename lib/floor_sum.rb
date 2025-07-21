# sum_{i = 1 .. n}{ \floor{frac{n}{i}} }
def floor_sum(n, mod = nil)
  sum = 0
  lim = n + 1
  r = Integer.sqrt(n)
  (1 .. r).each do |b|
    k = n / b
    sum += k
    sum += (b - 1) * (lim - k)
    sum %= mod if mod
    lim = k
  end
  sum += r * (lim - r) if lim > r
  sum %= mod if mod
  return sum
end

