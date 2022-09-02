require 'rails_helper'

describe "Items API" do
  it "sends list of all items" do

    merchant = create(:merchant)
    create_list(:item, 10, merchant_id: merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items).to have_key(:data)
    expect(Item.all.count).to eq(10)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  it "can get one item" do
    merchant = create(:merchant)
    item_id = create(:item, merchant_id: merchant.id).id

    get "/api/v1/items/#{item_id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)

    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to eq('item')

    expect(item[:data]).to have_key(:attributes)
    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes]).to have_key(:merchant_id)
  end

   it "can create a new item" do
      merchant = create(:merchant)
      item_params = ({name: "Item", description: "This is an item", unit_price: 1.50, merchant_id: (merchant.id)})
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      item = Item.last

      expect(response).to be_successful

      expect(item.name).to eq(item_params[:name])
      expect(item.name).to eq("Item")
      expect(item.description).to eq("This is an item")
      expect(item.unit_price).to eq(1.50)
      expect(item.merchant_id).to eq(merchant.id)
   end

   it "can update existing item record" do
      merchant_id = create(:merchant).id
      item_id = create(:item, merchant_id: merchant_id).id
      last_price = Item.last.unit_price
      updated_params = { unit_price: 1.00 }
      
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate({item: updated_params})

      item = Item.find_by(id: item_id)

      expect(response).to be_successful
      expect(item.unit_price).to_not eq(last_price)
       expect(item.unit_price).to eq(1.00)
  end

   it "can destroy an item" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
   end
end