require_relative './basket'

RSpec.describe 'Basket' do
  let(:basket) { Basket.new }

  {
    %w[B01 G01] => 37.85,
    %w[R01 R01] => 54.37,
    %w[R01 G01] => 60.85,
    %w[B01 B01 R01 R01 R01] => 98.27,
    %w[R01 R01 R01 R01] => 98.85
  }.each do |products, expected_total|
    context "when #{products}" do
      before do
        products.each { |product| basket.add_to_basket(product) }
      end

      it "returns total of #{expected_total}" do
        expect(basket.total).to eq(expected_total)
      end
    end
  end
end
