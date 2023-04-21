# L = ModLinear.create(13)
# f = L[3, 2] # 3 * x + 2 mod 13
# g = L[1, 1] # x + 1 mod 13
# h = f.synth(g) # g(f(x)) = f o g 
# L[f, g, h] # f o g o h
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
  def pow(n)
    c, d = 1, 0
    aa, bb = @a, @b
    while n > 0
      if n.odd?
        d = _to_i(bb + aa * d)
        c = _to_i(c * aa)
      end
      bb = _to_i(bb * aa + bb)
      aa = _to_i(aa * aa)
      n >>= 1
    end
    create(c, d)
  end
  # f o g
  def synth(g)
    create(_to_i(@a * g.a), _to_i(@b * g.a + g.b))
  end
  # fset is [f1, f2, f3]
  # f o f1 o f2 o f3 = f3(f2(f1(f(x))))
  def compose(*fset)
    c, d = @a, @b
    fset.each do |f|
      d = _to_i(f.b + f.a * d)
      c = _to_i(c * f.a)
    end
    create(c, d)
  end

  def inv
    raise if @a.zero?
    aa = @a.pow(@@_mod - 2, @@_mod)
    create(aa, _to_i(-@b * aa))
  end

  def inspect
    sprintf "#<LinearMod: %dx%+d mod %d>", @a, @b, @@_mod
  end

  def call(x); _to_i(@a * x + @b); end
  
  def create(a,b)
    self.class.new(a,b)
  end
  
  def create_or_compose(*fset)
    if fset.size == 2 && fset[0].is_a?(Integer) && fset[0].is_a?(Integer)
      create(fset[0], fset[1])
    elsif fset.all?{|f| f.is_a?(self.class) }
      compose(*fset)
    else
      raise "unsupported operation create_or_compose(#{fset})"
    end
  end
  alias_method :[], :create_or_compose

  private
  def _to_i(x); x % @@_mod; end
end
