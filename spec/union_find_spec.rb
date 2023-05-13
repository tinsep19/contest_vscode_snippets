require 'union_find'

RSpec.describe UnionFind do
  let!(:size){ 10 }
  let!(:x){ 2 }
  let!(:y){ 5 }
  subject(:g){ described_class.new(size) }

  describe "#initialize" do
    it { is_expected.to be_a UnionFind }
  end

  its(:size){ is_expected.to eq(size) }

  describe "#same?" do
    subject{ g.same?(x, y) }
    it { is_expected.to be_falsey }
    context "after merged" do
      before do
        g.merge(x, y)
      end
      it { is_expected.to be_truthy }
    end
  end

  describe "#merge" do
    subject!{ g.merge(x, y) }
    it { expect(g.leader(x) == g.leader(y)).to be_truthy }
  end
end