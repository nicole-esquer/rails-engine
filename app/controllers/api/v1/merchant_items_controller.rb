class Api::V1::MerchantItemsController < ApplicationController
   def index  
      merchant = Merchant.find(merchant_params[:id])
      render json: ItemSerializer.new(merchant.items)
   end

private
   
   def merchant_params
      params.permit(:id)
   end
end

