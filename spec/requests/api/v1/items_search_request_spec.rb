require 'rails_helper'

RSpec.describe 'items search' do
   xit 'can search by item name' do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)

      item_1 = create(:item, name: "Big Item 1", description: "This is big item number 1", unit_price: 1.50, merchant_id: merchant_1.id)
      item_2 = create(:item, name: "Small Item 2", description: "This is small item number 2", unit_price: 2.00, merchant_id: merchant_2.id)

      get '/api/v1/items/find?name=big'
   
      items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(items[:data].count).to eq(1)
   end
end