class Array
  def cumsum
    sum = Array.new(size, 0)
    i = 0; n = size
    sum[i] = sum[i - 1] + self[i - 1] while (i += 1) < n
    sum
  end
  def rcumsum
    sum = Array.new(size, 0)
    i = size - 1
    sum[i] = sum[i + 1] + self[i] while (i -= 1) >= 0
    sum
  end
  def cumsum0
    sum = Array.new(size + 1, 0)
    i = 0; n = size
    sum[i] = sum[i - 1] + self[i - 1] while (i += 1) <= n
    sum
  end
  def rcumsum0
    sum = Array.new(size + 1, 0)
    i = size
    sum[i] = sum[i + 1] + self[i] while (i -= 1) >= 0
    sum
  end
end

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
