# s2d[top, bottom, left, right] 
# sum rect of [top, bottom), [left, right)
# usage. 
# s2d = cumsum_2d([[1, 2],[3, 4]])
# p s2d[1,2,0,2] # => 7
# p s2d[0,2,0,1] # => 4

def cumsum_2d(array)
  h,w = array.size, array[0].size
  sum = Array.new(h + 1){ Array.new(w + 1, 0) }
  array.each_with_index{|row,y| row.each_with_index{|v, x| sum[y + 1][x + 1] = sum[y + 1][x] + sum[y][x + 1] - sum[y][x] + v } }
  ->(t,b,l,r){sum[b][r] - sum[t][r] - sum[b][l] + sum[t][l] }
end
