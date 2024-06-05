def cumsum(array)
  sum = Array.new(array.size + 1, 0)
  i = 0; n = array.size
  sum[i] = sum[i - 1] + array[i - 1] while (i += 1) <= n
  sum
end
def rcumsum(array)
  sum = Array.new(array.size + 1, 0)
  i = array.size
  sum[i] = sum[i + 1] + array[i] while (i -= 1) >= 0
  sum
end
