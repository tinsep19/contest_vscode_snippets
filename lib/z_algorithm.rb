def z_algorithm(s)
  n = s.size
  return [] if n == 0

  s = s.codepoints if s.is_a?(String)

  z = [0] * n
  z[0] = n
  i, j = 1, 0
  while i < n
    j += 1 while i + j < n && s[j] == s[i + j]
    z[i] = j
    if j == 0
      i += 1
      next
    end
    k = 1
    while i + k < n && k + z[k] < j
      z[i + k] = z[k]
      k += 1
    end
    i += k
    j -= k
  end

  return z
end
