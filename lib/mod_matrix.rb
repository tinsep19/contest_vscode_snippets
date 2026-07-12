MOD = 998244353
def mat_pow(mat, t)
  n = mat.size
  x = Array.new(n){ Array.new(n, 0) }
  n.times{|i| x[i][i] = 1 }
  while t > 0
    x = mat_x(mat, x) if t[0] > 0
    mat = mat_x(mat, mat)
    t >>= 1
  end
  x
end
def mat_x(a, b)
  b = b.transpose
  a.map do |row|
    b.map do |col|
      sum = 0
      i = row.size
      while (i -= 1) >= 0
        sum += row[i] * col[i]
      end
      sum % MOD
    end
  end
end

