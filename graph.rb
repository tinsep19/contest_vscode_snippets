class Graph
  class << self
    def load_graph(n, m)
      g = new(n)
      m.times do
        a,b = gets.split.map!(&:to_i)
        a -= 1; b -= 1;
        g.add_edge(a, b)
      end
      g
    end
    def load_tree(n)
      g = new(n)
      (n - 1).times do
        a,b = gets.split.map!(&:to_i)
        a -= 1; b -= 1;
        g.add_edge(a,b)
      end
      g
    end
  end
  def initialize(n = 0)
    @g = Array.new(n){[]}
  end
  def add_node; @g << []; @g.size - 1; end
  def add_edge(a,b); @g[a] << b; @g[b] << a; self; end
  def size; @g.size; end
  def [](i); @g[i]; end
end
