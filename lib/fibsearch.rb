# fibonacci search
# search min{ f[x] | x \in [l, r) } 
# if you want max, fix xa > xb -> xa < xb 
# call fibsearch(l, r){|x| -f(x) }
# a, b, c (a + b)
# a = b - a
# b = b - a
def fibsearch(l, r, &f)
  offset = l - 1; a = b = 1
  (b += a; a = b - a) while offset + b < r
  xa = xb = nil
  while b > 1
    xa ||= f[offset + a]
    xb ||= f[offset + b] if offset + b < r
    a = b - a; b = b - a
    if xb && xa > xb
      offset += b; xa = xb; xb = nil
    else
      xb = xa; xa = nil
    end
  end
  return xa || xb
end

def fibsearch_index(l, r, &f)
  offset = l - 1; a = b = 1
  (b += a; a = b - a) while offset + b < r
  xa, xb = nil, nil
  while b > 1
    xa ||= f[offset + a]
    xb ||= f[offset + b] if offset + b < r
    a = b - a; b = b - a
    if xb && xa > xb
      offset += b; xa = xb; xb = nil
    else
      xb = xa; xa = nil
    end
  end
  return offset + 1
end
