require 'tecc'
RSpec.describe TeCC do
  subject(:g) {
    g = TeCC.new(5)
    g.add_edge(0, 1)
    g.add_edge(1, 2)
    g.add_edge(0, 2)
    g.add_edge(1, 3)
    g.add_edge(2, 4)
    g
  }
  describe :tecc! do
    subject!{ g.tecc!; g }
    its(:ids) { is_expected.to be_an Array }
    its(:ids) { is_expected.to eq([0,0,0,2,1]) }

    its(:components) { is_expected.to be_an Array }
    its(:components) { is_expected.to eq([[0,1,2],[4],[3]]) }
  end
end