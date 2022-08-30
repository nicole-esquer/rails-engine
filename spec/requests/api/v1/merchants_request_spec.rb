require 'rails_helper'

RSpec.describe 'Merchants API' do
   it 'sends a list of merchants' do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(Merchant.count).to eq(3)

      expect(merchants).to have_key(:data)

      merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
   end
end

   xit 'can get one merchant by its id' do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to eq(id)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
   end   
end
