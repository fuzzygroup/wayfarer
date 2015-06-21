require "spec_helpers"

describe Schablone::HTTPAdapters do
  describe "::adapter_pool" do
    context "with Net/HTTP used" do
      it "returns a NetHTTPAdapter" do
        Schablone::HTTPAdapters.adapter_pool.with do |adapter|
          expect(adapter).to be_a NetHTTPAdapter
          fail "FUCK!!!"
        end
      end
    end
  end
end
