class ItemSerializer < ActiveModel::Serializer
  attributes :description, :id, :merchant_id, :name
  attribute :price, key: :unit_price

  def price
    (object.unit_price ? object.unit_price/100.00 : 0.0).to_s
  end


end
