class Array
  # compress! values and return values table.
  def compress!
    index = {}
    sort.each{|x| index[x] = index.size }
    map!{|x| index[x] }
    values = Array.new(index.size)
    index.each{|x, i| values[i] = x }
    values
  end
end

# return compressed new array
def compress(seq)
  index = {}
  seq.sort.each{|x| index[x] = index.size }
  seq.map{|x| index[x] }
end

# return compressed array.
def compress!(seq)
  index = {}
  seq.sort.each{|x| index[x] = index.size }
  seq.map!{|x| index[x] }
end
