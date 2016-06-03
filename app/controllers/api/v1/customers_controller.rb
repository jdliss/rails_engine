module Api
  module V1
    class CustomersController < SuperController
      create_methods :invoices, :transactions
    end
  end
end
