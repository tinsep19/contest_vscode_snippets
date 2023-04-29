# create multi dimensional arrays.
# dp_init([2,3,4])
# [ [ [nil, nil, nil, nil], 
#     [nil, nil, nil, nil], 
#     [nil, nil, nil, nil] ], 
#   [ [nil, nil, nil, nil],
#     [nil, nil, nil, nil],
#     [nil, nil, nil, nil] ] ]
def dp_init(d, e=nil);(f = ->(i){ i >= d.size ? e : Array.new(d[i]){ f[i+1] }})[0];end
