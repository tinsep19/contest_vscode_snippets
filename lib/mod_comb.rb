# C[n, r]
def mod_binom_1(mod)
  __minv = [0, 1]
  __finv = [1, 1]
  __fact = [1, 1]
  
  prepare  = ->(n){
    until (z = __fact.size) > n
      __minv.push( mod / z * (mod - __minv[mod % z]) % mod )
      __finv.push( __finv[z - 1] * __minv[z] % mod )
      __fact.push( __fact[z - 1] * z % mod )
    end
  }

  inv      = ->(n){ preapre[n]; __minv[n] }
  fact_inv = ->(n){ preapre[n]; __finv[n] }
  fact     = ->(n){ prepare[n]; __fact[n] }
  binom    = ->(n, r){
    return 0 if n < 0 || r < 0 || n < r
    prepare[n]
    __fact[n] * (__finv[r] * __finv[n-r] % mod) % mod
  }

end
def mod_binom_2(n, mod)
  c = [[0]]
  until c.size > n
    z = c.size
    r0 = c[-1]
    r1 = Array.new(z + 1, 1)
    c << r1

    i = 0
    r1[i] = (r0[i - 1] + r0[i]) % mod while (i += 1) < z

  end
  c
end
C = mod_binom_1(MOD = 998244353)
# C = mod_binom_2(50, MOD = 998244353)
