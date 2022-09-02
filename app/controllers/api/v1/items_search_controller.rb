class Api::V1::ItemsSearchController < ApplicationController

   def index
      items = Item.search_items(item_params)
      render json: ItemSerializer.new(items)
   end

   private

   def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
   end
end
