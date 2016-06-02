class InvoiceItemSerializer < ActiveModel::Serializer
  attributes :id, :invoice_id, :item_id, :quantity
  attribute :price, key: :unit_price

  def price
    (object.unit_price ? object.unit_price/100.00 : 0.0).to_s
  end
end
