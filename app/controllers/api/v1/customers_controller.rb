module Api
  module V1
    class CustomersController < SuperController
      respond_to :json

      def model
        controller_name.classify.constantize
      end

      def invoices
        respond_with @object.invoices
      end

      def transactions
        respond_with @object.transactions
      end
    end
  end
end
