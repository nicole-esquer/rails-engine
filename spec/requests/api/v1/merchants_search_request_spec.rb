require 'rails_helper'

RSpec.describe 'merchants search' do
   it 'can search merchant by name' do
      merchant_1 = create(:merchant, name: 'Post')
      merchant_2 = create(:merchant, name: 'Man')

      get '/api/v1/merchants/find?name=pos'

      merchant = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(merchant[:data][:attributes][:name]).to eq("Post")
   end
end