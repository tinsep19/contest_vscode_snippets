class LowLink
  def initialize(n)
    @g = Array.new(n){ [] }
  end
  def add_node; @g << []; @g.size - 1; end
  def add_edge(a,b); @g[a] << b ; @g[b] << a; self; end
  def bridges(s = 0)
    n = @g.size
    seq = []
    used = Array.new(n)
    ord = Array.new(n)
    low = Array.new(n)
    (dfs = ->(u, up) {
      used[u] = 0
      id = seq.size
      ord[u] = id
      low[u] = id
      seq << u
      @g[u].each do |v|
        next if v == up
        w = used[v] ? ord[v] : dfs[v, u]
        low[u] = w if w < low[u]
      end
      low[u]
    })[s, -1]
    br = []
    @g.each_with_index do |adj, u|
      adj.each do |v|
        br << [u, v] if ord[u] < ord[v] && ord[u] < low[v]
      end
    end
    br
  end
  
  def articulation_points(s = 0)
    n = @g.size
    seq = []
    used = Array.new(n)
    ord = Array.new(n)
    low = Array.new(n)
    (dfs = ->(u, up) {
      used[u] = 0
      id = seq.size
      ord[u] = id
      low[u] = id
      seq << u
      @g[u].each do |v|
        next if v == up
        if used[v]
          w = ord[v]
          low[u] = w if w < low[u]
        else
          w = dfs[v, u]
          low[u] = w if w < low[u]
          used[u] += 1 if u == s || w >= id
        end
      end
      low[u]
    })[s, -1]
    # articulation points is,
    # root has two or more children on DFS tree, 
    # Other, node (u) has at least one children (v) that satisfied low[v] < ord[u].
    used[s] -= 1
    n.times.select{|u| used[u] > 0 }
  end
  alias_method :disjoints, :articulation_points
  alias_method :cut_vertices, :articulation_points
end
