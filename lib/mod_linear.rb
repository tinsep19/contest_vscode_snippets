# L = ModLinear.create(13)
# f = L.create(3,2) # 3 * x + 2 mod 13
# g = L.create(3,2) # x + 1 mod 13
# h = f.synth(g) # g(f(x)) = g o f 
# L[f, g, h] # h o g o f
# f.inv # f^{-1}
class ModLinear
  class << self
    def create(mod)
      Class.new(self){ @@_mod = mod }.new
    end
  end
  attr_reader :a, :b
  def initialize(a = 1, b = 0)
    @a = a
    @b = b
  end
  def create(a,b)
    self.class.new(a,b)
  end
  def call(x); to_val(@a * x + @b); end
  def pow(n)
    c, d = 1, 0
    aa, bb = @a, @b
    while n > 0
      if n.odd?
        d = to_val(bb + aa * d)
        c = to_val(c * aa)
      end
      bb = to_val(bb * aa + bb)
      aa = to_val(aa * aa)
      n >>= 1
    end
    create(c, d)
  end
  def synth(g)
    create(to_val(@a * g.a), to_val(@b * g.a + g.b))
  end
  def inv
    raise if @a.zero?
    aa = @a.pow(@@_mod - 2, @@_mod)
    create(aa, to_val(-@b * aa))
  end
  def compose(*fset)
    c, d = @a, @b
    fset.each do |f|
      d = to_val(f.b + f.a * d)
      c = to_val(c * f.a)
    end
    create(c, d)
  end
  alias_method :[], :compose

  def mod; @@_mod; end
  def inspect
    sprintf "#<LinearMod: %dx%+d mod %d>", @a, @b, @@_mod

  end

  private
  def to_val(x); x % @@_mod; end
end
