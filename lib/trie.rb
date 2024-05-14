class Trie
  def initialize
    @node = []; @count = []; 
    @root = add_node
  end

  def size; count[@root]; end

  # add(seq, n)
  def add(seq, n = 1)
    @count[@root] += n
    seq.inject(@root){|u, label| node = @node[u]; node[label] ||= add_node(n) }
  end
  
  # follow(seq){|label, count| ... }
  def follow(seq, &block)
    return enum_for(:follow, seq) if !block
    seq.inject(@root){|u, label| v = @node[u][label]; break unless v; block[label, @count[v]] ; v}
  end
  
  private
  def add_node(n = 0)
    id = @node.size
    @node << {}
    @count << n
    id
  end
end
