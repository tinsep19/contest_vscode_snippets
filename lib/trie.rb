class Trie
  def initialize
    @node   = []
    @leaf   = []
    @prefix = []
    @root = add_node
  end
  def size; prefix[@root]; end

  def insert(seq, n = 1)
    t = seq.inject(@root) do |u, c|
      @prefix[u] += n
      node[u][c] ||= add_node
    end
    @prefix[t] += n
    @leaf[t]   += n
    return t
  end
  
  # delete leaf which represented by seq
  def delete(seq, n = 1)
    t = node_id(seq)
    return if !t || @leaf[t] < n
    seq.inject(@root) do |u, c|
      @prefix[u] -= n
      node[u][c]
    end
    @prefix[t] -= n
    @leaf[t]   -= n
  end
  
  # disjoint subtree by node which represented by preseq 
  def disjoint(preseq, n)
    t = node_id(preseq)
    return if !t
    f = @prefix[t]
    preseq.inject(@root) do |u, c|
      @prefix[u] -= f
      @node[u][c]
    end
    @prefix[t] = 0
    @leaf[t]   = 0
    @node[t]   = {}
    t
  end

  # return count of leaf which represented by seq
  def leaf(seq)
    t = node_id(seq)
    t && @leaf[t]
  end
  
  # return count of leaf which has seq as prefix
  def prefix(seq)
    t = node_id(seq)
    t && @prefix[t]
  end
  
  private
  def node_id(seq)
    seq.inject(@root) do |u, c|
      node = @node[u]
      return if !node[c]
      node[c]
    end
  end
  def add_node(n = 0)
    id = @node.size
    @leaf   << 0
    @prefix << 0
    @node   << {}
    id
  end
end
