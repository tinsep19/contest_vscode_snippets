class SPFA
  class << self
    def load_graph(n, m)
      g = new(n)
      m.times do
        a,b,w = gets.split.map(&:to_i)
        a -= 1; b -= 1;
        g.add_edge(a,b,w)
      end
      g
    end
    def load_di_graph(n, m)
      g = new(n)
      m.times do
        a,b,w = gets.split.map(&:to_i)
        a -= 1; b -= 1;
        g.add_di_edge(a,b,w)
      end
      g
    end
  end
  Edge = Struct.new(:to, :w)

  def initialize(n); @g = Array.new(n){ [] }; end
  def add_di_edge(a, b, w); @g[a] << Edge.new(b, w); self; end
  def add_edge(a,b,w); @g[a] << Edge.new(b, w); @g[b] << Edge.new(a, w); self; end

  def spfa(s)
    q = []
    dist = Array.new(@g.size, Float::INFINITY)
    rank = Array.new(@g.size, 0)
    inq = Array.new(@g.size)
    
    q << s
    dist[s] = 0
    inq[s] = true

    until q.empty?
      u = q.shift

      inq[u] = nil
      d = dist[u]
      r = rank[u]

      @g[u].each do |e|
        next if e.w + d >= dist[e.to]
        rank[e.to] = r + 1
        dist[e.to] = (r + 1 >= @g.size) ? -Float::INFINITY : d + e.w
        q << e.to if !inq[e.to]
        inq[e.to] = true
      end
    end
    dist
  end
  def min_cost_path(s,t); spfa(s)[t]; end
end
