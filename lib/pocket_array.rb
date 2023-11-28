# 配列中の値がある位置をO(log N)で求めるデータ構造
class PocketArray
  def initialize(n, &block)
    @prior = block || lambda{|a,b| !a ? b : !b ? a : a > b ? a : b }
    @offset = @size = 1 << (n - 1).bit_length
    @data = Array.new(@offset + @size)
  end
  def top; @data[1]; end
  def clear?(i); !@data[@offset+ i]; end
  def set?(i); @data[@offset + i]; end
  alias_method :[], :set?

  def set!(i, x)
    @data[i += @offset] = x
    @data[i] = @prior[@data[2 * i], @data[2 * i + 1]] while (i >>= 1) > 0
  end
  def clear!(i); set!(i, nil); end
  alias_method :[]=, :set!

  def prev_index(i)
    i += @offset
    i >>= 1 until i.zero? || (i[0] == 1 && @data[i ^ 1])
    return nil if i.zero?
    i -= 1
    until i >= @offset
      i <<= 1
      i += 1 if @data[i + 1]
    end
    i - @offset
  end

  def next_index(i)
    i += @offset
    i >>= 1 until i.zero? || (i[0].zero? && @data[i ^ 1])
    return nil if i.zero?
    i += 1

    while i < @offset
      i <<= 1
      i += 1 if !@data[i]
    end
    i - @offset
  end
end
