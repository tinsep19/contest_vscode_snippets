def comb(mod)
  minv = [0, 1]
  finv = [1, 1]
  fact = [1, 1]
  
  -> (n, r){
    return 0 if n < 0 || r < 0 || n < r
    until (z = fact.size) > n
      minv.push( mod / z * (mod - minv[mod % z]) % mod )
      finv.push( finv[z - 1] * minv[z] % mod )
      fact.push( fact[z - 1] * z % mod )
    end
    fact[n] * (finv[r] * finv[n-r] % mod) % mod
  }
end
C = comb(MOD = 998244353)
