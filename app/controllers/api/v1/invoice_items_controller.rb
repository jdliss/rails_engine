module Api
  module V1
    class InvoiceItemsController < SuperController
      create_methods :invoice, :item
    end
  end
end
