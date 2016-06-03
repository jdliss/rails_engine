module Api
  module V1
    class InvoicesController < SuperController
      create_methods :transactions, :invoice_items, :items, :customer, :merchant
    end
  end
end
