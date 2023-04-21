require 'union_find'

RSpec.describe UnionFind do
  let!(:size){ 10 }
  subject(:g){ described_class.new(size) }
  describe "#initialize" do
    it { expect(subject.size).to eq size }
    it { expect(subject.group_size).to eq size }
  end
  
  describe "#merge" do
    let!(:x){ 2 }
    let!(:y){ 5 }
    subject!{ g.merge(x, y) }

    it { expect(g.group_size).to eq(size - 1) }
    it { expect(g.same?(x,y)).to be_truthy }
  end

end