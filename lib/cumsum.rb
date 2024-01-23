def cumsum(array)
  sum = Array.new(array.size + 1, 0)
  array.each_with_index{|x,i| sum[i + 1] = sum[i] + x }
  sum
end
