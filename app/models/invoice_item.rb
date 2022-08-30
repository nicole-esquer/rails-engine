class InvoiceItem < ApplicationRecord
   validates_presence_of :quantity
   validates_presence_of :unit_price

   belongs_to :invoice
   belongs_to :item
end