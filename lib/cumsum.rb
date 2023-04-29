# usage.
# s = cumsum([1, 2, 3, 4])
# p s[0, 4] # => 10 
# p s[1, 4] # => 5
def cumsum(array)
  sum = Array.new(array.size + 1, 0)
  array.each_with_index{|v,i| sum[i + 1] = sum[i] + v }
  ->(l, r){ sum[r] - sum[l] }
end