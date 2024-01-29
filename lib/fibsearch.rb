# fibonacci search
# search min{ f[x] | x \in [l, r) } 
# if you want max, fix xa > xb -> xa < xb 
# call fibsearch(l, r){|x| -f(x) }

def fibsearch(l, r, &f)
  offset, a, b = l - 1, 1, 1
  a, b = b, b + a while offset + b < r
  xa, xb = nil, nil
  while b > 1
    xa ||= f[offset + a]
    xb ||= f[offset + b] if offset + b < r
    a, b = b - a, a
    if xb && xa > xb
      offset, xa, xb = offset + b, xb, nil
    else
      xa, xb = nil, xa
    end
  end
  return xa || xb
end

def fibsearch_index(l, r, &f)
  offset, a, b = l - 1, 1, 1
  a, b = b, b + a while offset + b < r
  xa, xb = nil, nil
  while b > 1
    xa ||= f[offset + a]
    xb ||= f[offset + b] if offset + b < r
    a, b = b - a, a
    if xb && xa > xb
      offset, xa, xb = offset + b, xb, nil
    else
      xa, xb = nil, xa
    end
  end
  return offset + 1
end
