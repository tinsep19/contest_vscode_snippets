class Graph
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
  def add_di_edge(a,b,w=1); @g[a] << Edge.new(b, w); self; end
  def add_edge(a,b,w=1); @g[a] << Edge.new(b, w);@g[b] << Edge.new(a, w); self; end

  # dijkstra(s) -> Array # dist[t] : total cost of s - t
  def dijkstra(s)
    q = Heap.new
    dist = Array.new(@g.size, Float::INFINITY)
    dist[s] = 0
    q.push(0, s)
    
    until q.empty?
      d, u = q.pop
      next if d != dist[u]
      @g[u].each do |e|
        sw = d + e.w
        next if sw >= dist[e.to]
        dist[e.to] = sw
        q.push(sw, e.to)
      end
    end
    return dist
  end

  # push(priority, element), enq(priority, element)
  # pop -> [priority, element], deq -> [priority, element]
  class Heap
    def initialize; @h = []; end
    def enq(pr,el); @h << [pr,el]; up_heap; end
    def empty?; @h.empty?; end
    def deq
      return nil if @h.empty?
      @h[0],@h[-1] = @h[-1],@h[0]
      x = @h.pop
      down_heap if @h.size >= 2
      x
    end
    alias_method :pop, :deq
    alias_method :push, :enq

    private
    def up_heap
      i = @h.size-1
      pr,_el = x = @h[i]
      while i > 0
        up = (i - 1) / 2
        break if @h[up][0] <= pr
        @h[i], i = @h[up], up
      end
      @h[i] = x
    end

    def down_heap
      i = 0
      pr,_el = x = @h[i]
      z = @h.size
      while (c = i + i + 1) < z
        c += 1 if c + 1 < z && @h[c + 1][0] < @h[c][0]
        break if pr <= @h[c][0]
        @h[i], i = @h[c], c
      end
      @h[i] = x
    end
  end
end
