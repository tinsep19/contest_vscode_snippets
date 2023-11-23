require 'fibsearch'
RSpec.describe "#fibsearch" do
  let!(:set){ [5,3,2,-1,-2,0,5,10] }
  describe "#fibsearch" do
    it "minimal-value is -2" do
      expect( fibsearch(0, set.size){|i| set[i] } ).to eq(-2)
    end
  end
  describe "#fibsearch_index" do
    it "minimal-index is 4" do
      expect( fibsearch_index(0, set.size){|i| set[i] } ).to eq(4)
    end
  end
end