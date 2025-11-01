class ParallelBinarySearch
  # block evaluate on instance_exec
  # you can access eset as @events, qset as @queries 
  def initialize(eset, qset, &block)
    @events = eset
    @queries = qset
    instance_exec(&block) if block_given?
    req = [:on_event, :on_query, :on_clear]
    raise "it must have #{req}" unless req.all?{ respond_to? _1 }
  end
  # [ nil | num , ... ]
  def bsearch
    ez = @events.size
    qz = @queries.size
    lo = Array.new(qz, -1)
    hi = Array.new(qz, ez)
    buckets = Array.new(ez){[]}
    buckets[(ez - 1)/2] = Array.new(qz){_1}
    
    count = qz
    while count > 0
      e = -1
      while (e += 1) < ez
        on_event(e)
        b = buckets[e]
        until b.empty?
          q = b.pop
          if on_query(q)
            hi[q] = e
          else
            lo[q] = e
          end
          if lo[q] + 1 < hi[q]
            mid = (lo[q] + hi[q]) / 2
            buckets[mid] << q
          else
            count -= 1
          end
        end
      end
      on_clear
    end
    hi.map!{_1 >= ez ? nil : _1 }
  end
end
PBS = ParallelBinarySearch
# comment in, below
# 
# pbs = PBS.new(eset, qset) do
#   def on_event(e)
#     @events[e]
#   end
#   def on_query(q)
#     @queries[q]
#   end
#   def on_clear
#   end
# end
