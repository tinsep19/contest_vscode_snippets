class Trie
  def initialize
    @node = []
    @leaf = []
    @flow = []
    @root = add_node
  end
  def size; @flow[@root]; end

  # insert leaf which represented by seq
  def insert(seq, n = 1)
    t = seq.inject(@root) do |u, c|
      @flow[u] += n
      @node[u][c] ||= add_node
    end
    @flow[t] += n
    @leaf[t] += n
    return t
  end
  
  # delete leaf which represented by seq
  def delete(seq, n = 1)
    t = node_id(seq)
    return if !t || @leaf[t] < n
    seq.inject(@root) do |u, c|
      @flow[u] -= n
      @node[u][c]
    end
    @flow[t] -= n
    @leaf[t] -= n
  end
  
  # disjoint subtree by node which represented by preseq 
  def disjoint(preseq)
    t = node_id(preseq)
    return if !t
    f = @flow[t]
    preseq.inject(@root) do |u, c|
      @flow[u] -= f
      @node[u][c]
    end
    @flow[t] = 0
    @leaf[t] = 0
    @node[t] = {}
    t
  end

  # return count of leaf which represented by seq
  def leaf(seq)
    t = node_id(seq)
    t && @leaf[t]
  end
  
  # return count of leaf which has seq as prefix
  def flow(seq)
    t = node_id(seq)
    t && @flow[t]
  end

  # follow(seq){|path, flow, leaf| }
  # follow(seq) => Enumerator
  def follow(seq)
    return enum_for(:follow, seq) unless block_given?
    prefix = []
    t = seq.inject(@root) do |u, c|
      yield prefix, @flow[u], @leaf[u]
      v = @node[u][c]
      return if !v
      prefix << c
      v
    end
    yield prefix, @flow[t], @leaf[t]
  end
  
  private
  def node_id(seq)
    seq.inject(@root){|u, c| @node[u][c] || return }
  end
  def add_node(n = 0)
    id = @node.size
    @leaf << 0
    @flow << 0
    @node << {}
    id
  end
end
