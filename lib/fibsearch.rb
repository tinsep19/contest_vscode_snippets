# fibsearch(l, r){|i, j| } # l <= i < j < r
# return i of argmin{ f(i) } 
# block must return true when i has higher priority than j.
def fibsearch(l, r, &block)
  offset, a, b = l - 1, 1, 1
  a, b = b, b + a while offset + a + b < r
  while b > 1
    offset += a if offset + b < r && !block[offset + a, offset + b]
    a, b = b - a, a
  end
  return offset + 1
end
# Example. 
# search minimal values in array. array is convex downward values.
# array = [5,4,3,2,1,2,3,4,5]
# fibsearch(0, array.size){|i, j| array[i] < array[j] } # 4
