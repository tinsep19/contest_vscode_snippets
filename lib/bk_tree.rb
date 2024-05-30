# 最近傍点を探すBk木(2次元のみ)
class BkTree
  
  # 点群からBk木を作成する
  # set : [[y0, x0], [y1, x1], ... ]
  def initialize(set, n = set.size)
    @size = n
    raise if set.size < n

    # transposeして[[y0, y1, y2 ...],[x0, x1, x2 ...]]の形で管理する
    @node = set[0, n].transpose
    @axis = Array.new(n)
    @left  = Array.new(n, -1)
    @right = Array.new(n, -1)
    @root = create_bk_tree
  end
  
  # nearest_norm2
  # 最近傍点の距離の2乗を返す。
  # limit2 : limit2 以下の点が見つかった場合は打ち切る(クエリ点群の最遠点を求める場合の枝刈り) 距離の2乗であることに注意.
  def nearest_norm2(r, limit2 = 0)
    ret = [Float::INFINITY, -1]
    find(@root, r, ret, limit2)
    return ret[0]
  end
  
  def nearest_point_id(r)
    ret = [Float::INFINITY, -1]
    find(@root, r, ret, 0)
    return ret[1]
  end
  
  # [y, x]
  def nearest_point(r)
    ret = [Float::INFINITY, -1]
    find(@root, r, ret, 0)
    id = ret[1]
    [@node[0][id], @node[1][id]]
  end

  # [y, x, norm2]
  def nearest_point_with_norm2(r)
    ret = [Float::INFINITY, -1]
    find(@root, r, ret, 0)
    id = ret[1]
    [@node[0][id], @node[1][id], ret[0]]
  end

  # [y, x, norm]
  def nearest_point_with_norm(r)
    ret = [Float::INFINITY, -1]
    find(@root, r, ret, 0)
    id = ret[1]
    [@node[0][id], @node[1][id], Math.sqrt(ret[0])]
  end
  
  private
  # 点群から2分木を作成して、根のノード番号を返す
  def create_bk_tree
    y_values = @node[0]
    x_values = @node[1]
    inf = 1 << 30
    
    yseq = @size.times.sort_by{|i| y_values[i] * inf + x_values[i] }
    xseq = @size.times.sort_by{|i| y_values[i] + inf * x_values[i] }
    rank = Array.new(@size, 0)

    create_node(yseq, xseq, 0, 1, rank)
  end
  
  # 再帰で点群を中心、左右に分けていく、戻り値は中心のid
  # yseq, xseqは昇順に並べた点群のid列 (頭にy, xとあるが、kの値により異なるので注意)
  # 
  # yseq : 優先軸: 親点で分割に使用した軸
  # xseq : 次点軸: yseqとは異なる軸
  # k : yseqが y軸かx軸か (0: y軸, 1: x軸). 反転する場合は 1 - k で可能
  # r : 点群のrank 再帰の際に左を2 * r, 右を2 * r + 1 とする
  # rank : 点群全体のrank
  def create_node(yseq, xseq, k, r, rank)
    if yseq.size == 1
      id = yseq[0]
      @axis[id] = k
      return id
    end
    
    # 分割軸の決定
    
    if @node[k][yseq[0]] == @node[k][yseq[-1]]
      # 優先軸の値がすべて同じ場合は別の軸と交換
      t = yseq
      yseq = xseq
      xseq = t
      k = 1 - k
    elsif @node[1 - k][xseq[0]] == @node[1 - k][xseq[-1]]
      # 次点軸がすべて同じ場合は現在の軸をそのまま使用
      # do nothing
    else
      # 分散を利用して軸を決定
      d1 = variance(yseq, k)
      d2 = variance(xseq, 1 - k)
      (t = yseq; yseq = xseq; xseq = t; k = 1 - k) if d1 < d2
    end
    
    # 中心の決定
    # 中央値を元に決定する
    x = @node[k][yseq[yseq.size / 2]]
    id = nil
    
    if @node[k][yseq[0]] == x
      # 先頭が中央値と同じ場合、左の点群をまとめる
      id = yseq.bsearch{|i| @node[k][i] > x }
    else
      # 中央値と同じ値の先頭を中心にする(うまくいくと右の子で分割軸がまとまる)
      id = yseq.bsearch{|i| @node[k][i] >= x }
    end
    raise "id is nil! d1 = #{d1}, d2 = #{d2}, #{yseq.map{ @node[1 - k][_1] }}" if id.nil?

    # yseq, xseqを左右の二つに分ける。どちらも昇順なのを使用してO(N)で処理
    yseq1 = []; xseq1 = []
    yseq2 = []; xseq2 = []

    l_rank = 2 * r
    r_rank = 2 * r + 1
    g = l_rank
    
    yseq.each do |j| 
      y = @node[k][j]
      if j == id
        g = r_rank
      elsif g == l_rank
        rank[j] = l_rank
        yseq1 << j
      elsif g == r_rank
        rank[j] = r_rank
        yseq2 << j
      end
    end
    
    xseq.each do |j|
      if rank[j] == l_rank
        xseq1 << j
      elsif rank[j] == r_rank
        xseq2 << j
      end
    end
    
    @axis[id] = k
    # 再帰的に左右の点群を分割
    @left[id]  = create_node(yseq1, xseq1, k, l_rank, rank) if yseq1.size > 0
    @right[id] = create_node(yseq2, xseq2, k, r_rank, rank) if yseq2.size > 0

    # 中央の点を返す
    return id
  end

  def find(id, r, found, limit2)
    d = found[0]
    return d if id < 0 || d <= limit2
    
    dd = norm2(id, r)
    if dd < d
      d = dd
      found[0] = dd
      found[1] = id
    end
    return 0 if dd.zero?
    return dd if dd <= limit2
    
    k = @axis[id]
    f = fence2(id, r)
    
    if r[k] < @node[k][id]
      d = find(@left[id], r, found, limit2)
      return d if f > d
      return find(@right[id], r, found, limit2)
    else
      d = find(@right[id], r, found, limit2)
      return d if f > d
      return find(@left[id], r, found, limit2)
    end
  end
  
  # 点群のk軸での分散を計算
  def variance(seq, k)
    n = seq.size
    s1 = s2 = 0
    seq.each{|i| x = @node[k][i] ; s2 += (x * x) ; s1 += x }
    n * s2 - (s1 * s1)
  end
  
  # 分割面までの距離
  def fence2(id, r)
    k = @axis[id]
    dx = @node[k][id] - r[k]
    dx * dx
  end
  
  # idで表される点とクエリ点との距離
  def norm2(id, r)
    dy = @node[0][id] - r[0]
    dx = @node[1][id] - r[1]
    dy * dy + dx * dx
  end
end
