# 最大流(Dinic法)
# g = Flow.new; s = g.add_node; t = g.add_node; v = g.add_node, ...
# g.add_edge(s, v); g.add_edge(v, t);
# g.max_flow(s,t) or g.push(s, t, limit)
# 
# 最大流のうち、ある辺の流量を最小にするようなフローを求める例
# https://atcoder.jp/contests/abc263/tasks/abc263_g
class Flow
  Edge = Struct.new(:to, :cap, :rev)
  def push(s, t, limit = Float::INFINITY)
    flow = 0
    active = Array.new(@g.size, -1)
    level = Array.new(@g.size)
    
    while limit > 0 && levelize(s, t, level)
      while find_flow(s, t, level, active)
        f = push_flow(s, t, limit, active)
        limit -= f
        flow  += f
      end
      active.fill(-1)
    end
    flow
  end
  alias_method :max_flow, :push
  
  # 残余ネットワークで到達可能かどうかを返す
  # F.push(s,t)
  # reachables = F.min_cut(s)
  # blocked = E.select{|from,to| reachables[from] & !reacheables[to] }
  # カットの復元につかう(see. ABC239 G)
  def min_cut(s)
    used = Array.new(@g.size, false)
    q = [s]
    used[s] = true
    until q.empty?
      u = q.shift
      @g[u].each do |e|
        next if e.cap.zero? || used[e.to]
        used[e.to] = true
        q << e.to
      end
    end
    used
  end
 
  def initialize(n = 0); @g = Array.new(n){ [] }; end
  def add_node; @g << []; @g.size - 1; end
  def size; @g.size; end
    
  def add_edge(from, to, cap = 1)
    raise "self loop is unsupported" if from == to
    fwd, rev = @g[from].size, @g[to].size
    @g[from] << Edge.new(to, cap, rev)
    @g[to] << Edge.new(from, 0, fwd)
    self
  end
  
  def add_bi_edge(u, v, cap = 1)
    raise "self loop is unsupported" if from == to
    u_index, v_index = @g[u].size, @g[v].size
    @g[u] << Edge.new(v, cap, v_index)
    @g[v] << Edge.new(u, cap, u_index)
    self
  end
  
  private

  def _min(a,b); a < b ? a : b; end
  
  def levelize(s, t, level)
    level.fill(@g.size * 2)
    level[t] = 0
    q = [t]
    until q.empty?
      u = q.shift
      d = level[u]
      next if u == s
      @g[u].each do |e|
        v = e.to
        rev = @g[e.to][e.rev] 
        # tからbfsしているので逆辺の容量を確認
        if rev.cap > 0 && level[v] > d + 1
          level[v] = d + 1
          q << v
        end
      end
    end
    return false if level[s] > @g.size
    level[s] = @g.size
  end

  def find_flow(s, t, level, active)
    stack = [s]
    while u = stack[-1]
      return true if u == t
      
      active[u] += 1
      e = @g[u][active[u]]
      if e.nil?
        stack.pop
      elsif e.cap > 0 && level[e.to] < level[u]
        stack << e.to
      end
    end
  end

  def push_flow(s, t, f, active)
    u = s
    until u == t
      fwd = @g[u][active[u]]
      f = _min(fwd.cap, f)
      u = fwd.to
    end
    u = s
    until u == t
      fwd = @g[u][active[u]]
      rev = @g[fwd.to][fwd.rev]
      fwd.cap -= f
      rev.cap += f
      active[u] -= 1 if fwd.cap > 0
      u = fwd.to
    end
    return f
  end
end
