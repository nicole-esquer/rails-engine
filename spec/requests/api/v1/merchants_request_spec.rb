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

  it 'can get one merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a(String)

    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to have_key(:name)

    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to eq('merchant')
  end

  it 'can get all merchant items' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    item_1 = create_list(:item, 1, merchant_id: merchant_1.id)
    item_2 = create_list(:item, 2, merchant_id: merchant_2.id)

    get "/api/v1/merchants/#{merchant_1.id}/items"

    merchant_items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant_items).to have_key(:data)

    expect(merchant_1.items.count).to eq(1)
    expect(merchant_1.items.count).to_not eq(2)
  end

  it 'can return a single merchant which matches a search term' do
    merchant = create(:merchant, name: 'First')
    merchant2 = create(:merchant, name: 'Second')
    merchant3 = create(:merchant, name: 'Third')

    search = 'TV'

    get "/api/v1/merchants/find?name=#{search}"

    search_result = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(search_result).to have_key(:data)
  end

  it 'will return an empty object if no match is found' do
    merchant = create(:merchant, name: 'Turing')
    merchant2 = create(:merchant, name: 'Ring World')
    merchant3 = create(:merchant, name: 'Tuna Stop')

    search = 'xylophone'

    get "/api/v1/merchants/find?name=#{search}"

    search_result = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(200)
  end

  it 'will return 400 if no search params specified' do
    merchant = create(:merchant, name: 'Turing')
    merchant2 = create(:merchant, name: 'Ring World')
    merchant3 = create(:merchant, name: 'Tuna Stop')

    get '/api/v1/merchants/find?name='

    expect(response).to have_http_status(400)
  end
end
