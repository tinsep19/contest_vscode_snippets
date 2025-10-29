# ===== 2本のBITを使って Range Add / Range Sum を実現 =====
class RangeBIT
  def initialize(n)
    @n = n
    @bit1 = BIT.new(n + 1)
    @bit2 = BIT.new(n + 1)
  end
  # 区間 [l, r) に +x 加算（0-indexed, 半開区間）
  def range_add(l, r, x)
    _add(@bit1, l, x)
    _add(@bit1, r, -x)
    _add(@bit2, l, x * l)
    _add(@bit2, r, -x * r)
  end

  # [0, idx) の和を取得
  def prefix_sum(idx)
    @bit1.sum(idx) * idx - @bit2.sum(idx)
  end

  # 区間 [l, r) の和を取得
  def range_sum(l, r)
    prefix_sum(r) - prefix_sum(l)
  end

  private

  def _add(bit, idx, x)
    bit.add(idx, x) if idx >= 0 && idx < @n + 1
  end
  # ===== Fenwick Tree (BIT) =====
  class BIT
    def initialize(n)
      @n = n
      @bit = Array.new(n + 1, 0)
    end

    def add(idx, x)
      idx += 1  # 0-indexed → 1-indexed
      while idx <= @n
        @bit[idx] += x
        idx += idx & -idx
      end
    end

    # [0, idx) の和を取得
    def sum(idx)
      s = 0
      while idx > 0
        s += @bit[idx]
        idx -= idx & -idx
      end
      s
    end
  end
end
