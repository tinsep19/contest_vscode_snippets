class Trie
  class Node
    attr_accessor :flow, :leaf
    def initialize
      @g = {}
      @leaf = 0
      @flow = 0
    end
    def [](i); @g[i]; end
    def []=(i, node); @g[i]=node; end
  end
  def initialize(node = nil)
    @root = node || Node.new
  end
  def size; @root.flow; end

  # get node by seq
  # @return node represented by seq
  def find_node(seq)
    seq.inject(@root){|node, c| node[c] || return }
  end

  # insert leaf which represented by seq
  # @return leaf size
  def insert(seq, n = 1)
    t = seq.inject(@root) do |node, c|
      node.flow += n
      node[c] ||= Node.new
    end
    t.flow += n
    t.leaf += n
  end
  alias_method :add, :insert

  # delete leaf which represented by seq
  def delete(seq, n = 1)
    t = find_node(seq)
    return if !t || t.leaf < n
    seq.inject(@root) do |node, c|
      node.flow -= n
      node[c]
    end
    t.flow -= n
    t.leaf -= n
  end
  
  # follow(seq){|path, node| }
  # @return nil | node which represented by seq
  def follow(seq)
    return enum_for(:follow, seq) unless block_given?
    path = []
    t = seq.inject(@root) do |node, c|
      yield path, node
      path << c
      node[c] || return
    end
    yield path, t
    t
  end
  alias_method :each, :follow
  
  # disjoint subtree by node which represented by preseq 
  # @return node represented by prefix
  def disjoint(prefix)
    t = find_node(prefix) || return
    f = t.flow
    prefix.inject(@root) do |node, c|
      node.flow -= f
      node[c] = nil if node[c] == t
      node[c]
    end
    t
  end
  alias_method :split, :disjoint
end
