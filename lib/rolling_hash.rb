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
# puts rh.joiner.add(r2[0, 2], 2).add(r1[7, 10], 3).hash

module RollingHash
  class << self
    def create(max)
      x = MulMod61.create_root(max)
      Param61.new(x)
    end
  end
  
  module MulMod61
    MASK30 = (1 << 30) - 1;
    MASK31 = (1 << 31) - 1;
    MOD = (1 << 61) - 1;
    MASK61 = MOD;
    SEED = 37
    
    class << self
      def create_root(max)
        k = 0; x = 0
        k = rand(MOD) until k.gcd(MOD - 1) == 1 && (x = SEED.pow(k, MOD)) > max
        x
      end
    end

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
    def mod; MOD; end
  end

  class Param61
    include MulMod61
    attr_reader :x, :inv, :pow
    def initialize(max)
      k = 0; x = 0
      k = rand(MOD) until k.gcd(MOD - 1) == 1 && (x = SEED.pow(k, MOD)) > max
      @x = x
      @pow = [1, x]
      @inv = [1, x.pow(MOD - 2, MOD)]
    end

    def cumsum(seq)
      prepare(seq.size)
      Cumsum.new(seq, self)
    end
    
    def segment_tree(seq)
      prepare(seq.size)
      SegmentTree.new(seq, self)
    end

    def prepare(size)
      x = @pow[1]; y = @inv[1];
      until @pow.size > size
        @pow << _mul(@pow[-1], x)
        @inv << _mul(@inv[-1], y)
      end
    end
    
    def joiner
      Join.new(self)
    end
  end

  class Join
    attr_reader :hash, :size
    def initialize(param)
      @param = param
      reset!
    end
    def reset!
      @hash = 0
      @size = 0
    end

    def add(hash, size)
      @param.prepare(@size)
      param = @param
      pow = param.pow
      @hash = param._mod(@hash + param._mul(hash, pow[@size]))
      @size += size
      self
    end
  end
  
  class SegmentTree
    include MulMod61
    def initialize(seq, param)
      @size = seq.size
      @param = param
      @offset = (1 << (@size - 1).bit_length)
      @data = Array.new(@offset << 1, 0)
      build!(seq)
    end
    def build!(seq)
      param = @param
      pow = param.pow
      seq.each_with_index{|x,i| @data[@offset + i] = param._mul(x, pow[i]) }
      i = @offset
      @data[i] = param._mod(@data[2 * i] + @data[2 * i + 1]) while (i -= 1) > 0
    end
    def update(i, x)
      k = @offset + i
      @data[k] = _mul(x, @param.pow[i])
      @data[k] = _mod(@data[2 * k] + @data[2 * k + 1]) while (k >>= 1) > 0
    end
    alias_method :[]=, :update
    def query(l, r)
      param = @param
      inv = @param.inv[l]
      w = r - l
      l += @offset
      r += @offset
      x = 0
      while l < r
        (x = param._mod(x + @data[l]); l += 1) if l.odd?
        (r -= 1; x = param._mod(x + @data[r])) if r.odd?
        l >>= 1; r >>= 1
      end
      param._mul(x, inv)
    end
    alias_method :[], :query
  end

  class Cumsum
    def initialize(seq, param)
      @param = param
      pow = @param.pow
      @size = seq.size
      @sum = Array.new(seq.size + 1, 0)
      seq.each_with_index{|x,i| @sum[i + 1] = param._mod(@sum[i] + param._mul(x, pow[i])) }
    end
    def [](l,r)
      param = @param
      inv = param.inv[l]
      x = @sum[r] - @sum[l]
      x += param.mod if x < 0
      param._mul(x, inv)
    end
  end
end
