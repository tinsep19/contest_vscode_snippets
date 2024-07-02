# Usage. 
# rh = RollingHash.create(1000)
# seq = [1, 2, 3, 4, 5, 1, 2, 3, 4, 5]
# r1 = rh.cumsum(seq)       # cumsum is static
# r2 = rh.segment_tree(seq) # segment_tree is dynamic. 
# # show hash of [3,4,5]
# puts r1[2, 5]
# puts r2[2, 5]
#
# # show hash of [1, 2, 3, 4, 5]
# puts r1[0, 5]
# puts rh.join(r2[5, 7], 2, r1[7, 10], 3)

module RollingHash
  class << self
    def create(max)
      Param.new(max)
    end
  end
  
  module MulMod
    MASK30 = (1 << 30) - 1;
    MASK31 = (1 << 31) - 1;
    MOD = (1 << 61) - 1;
    MASK61 = MOD;
    SEED = 37
      # a*b mod 2^61-1を返す関数(最後にModを取る)
    def _mul(a, b)
      au = a >> 31
      ad = a & MASK31
      bu = b >> 31
      bd = b & MASK31
      mid = ad * bu + au * bd
      midu = mid >> 30
      midd = mid & MASK30
      _mod(au * bu * 2 + midu + (midd << 31) + ad * bd)
    end

    # mod 2^61-1を計算する関数
    def _mod(x)
        xu = x >> 61
        xd = x & MASK61
        res = xu + xd
        res -= MOD if res >= MOD
        res
    end
  end
  
  class SegmentHash
    attr_reader :hash, :size, :param
    def initialize(hash, size, param)
      @size = size; @hash = hash; @param = param
    end
  end
  
  class Param
    include MulMod
    attr_reader :x, :inv, :pow
    def initialize(max)
      k = 0; x = 0
      k = rand(MOD) until k.gcd(MOD - 1) == 1 && (x = SEED.pow(k, MOD)) > max
      @x = x
      @pow = [1, x]
      @inv = [1, x.pow(MOD - 2, MOD)]
    end
    def mod; MOD; end

    def _prepare(z)
      x = @pow[1]; y = @inv[1];
      until @pow.size > z
        @pow << _mul(@pow[-1], x)
        @inv << _mul(@inv[-1], y)
      end
    end

    def join(*hz)
      x = 0; offset = 0;
      hz.each do |seg|
        raise if seg.param != self
        size = seg.size
        _prepare(offset)
        x = _mod(x + _mul(seg.hash, @pow[offset]))
        offset += size
      end
      return SegmentHash.new(x, offset, self)
    end
  
    def cumsum(seq)
      _prepare(seq.size)
      Cumsum.new(seq, self)
    end
    
    def segment_tree(seq)
      _prepare(seq.size)
      SegmentTree.new(seq, self)
    end
  end

  class SegmentTree
    include MulMod
    def initialize(seq, param)
      @size = seq.size
      @param = param
      @offset = (1 << (@size - 1).bit_length)
      @data = Array.new(@offset << 1, 0)
      build!(seq)
    end
    def build!(seq)
      pow = @param.pow
      seq.each_with_index{|x,i| @data[@offset + i] = _mul(x, pow[i]) }
      i = @offset
      @data[i] = _mod(@data[2 * i] + @data[2 * i + 1]) while (i -= 1) > 0
    end
    def update(i, x)
      k = @offset + i
      @data[k] = _mul(x, @param.pow[i])
      @data[k] = _mod(@data[2 * k] + @data[2 * k + 1]) while (k >>= 1) > 0
    end
    alias_method :[]=, :update
    def query(l, r)
      inv = @param.inv[l]
      w = r - l
      l += @offset
      r += @offset
      x = 0
      while l < r
        (x = _mod(x + @data[l]); l += 1) if l.odd?
        (r -= 1; x = _mod(x + @data[r])) if r.odd?
        l >>= 1; r >>= 1
      end
      SegmentHash.new(_mul(x, inv), w, @param)
    end
    alias_method :[], :query
  end

  class Cumsum
    include MulMod
    def initialize(seq, param)
      @param = param
      @size = seq.size
      @sum = Array.new(seq.size + 1, 0)
      pow = @param.pow
      seq.each_with_index{|x,i| @sum[i + 1] = _mod(@sum[i] + _mul(x, pow[i])) }
    end
    def [](l,r)
      w = r - l
      x = @sum[r] - @sum[l]
      x += MOD if x < 0
      SegmentHash.new(x, w, @param)
    end
  end
end

