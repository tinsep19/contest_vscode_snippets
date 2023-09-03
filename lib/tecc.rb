class TeCC
  def initialize(n)
    @g = Array.new(n){[]}
  end
  def add_edge(a,b)
    @g[a] << b
    @g[b] << a
  end
  attr_reader :ids
  attr_reader :components
  def tecc!
    low = Array.new(@g.size)
    ord = Array.new(@g.size)
    seq = []
    dfs = ->(u, up) {
      low[u] = ord[u] = seq.size
      seq << u
      @g[u].each do |v|
        next if v == up
        w = nil
        if ord[v]
          low[u] = ord[v] if ord[v] < low[u]
        else
          w = dfs[v, u]
          low[u] = w if w < low[u]
        end
      end
      low[u]
    }
    dfs[0, 0]
    @components = []
    @ids = Array.new(@g.size)
    used = Array.new(@g.size)

    dfs2 = ->(u, up, c, r) {
      used[u] = true
      c << u
      @ids[u] = r
      @g[u].each do |v|
        next if used[v] || ord[u] < low[v]
        dfs2[v, u, c, r]
      end
      c
    }
    seq.each do |u|
      next if used[u]
      @components << dfs2[u, u, [], @components.size]
    end
    self
  end
end