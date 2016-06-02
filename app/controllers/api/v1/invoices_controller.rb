module Api
  module V1
    class InvoicesController < SuperController
      respond_to :json

      def model
        controller_name.classify.constantize
      end

      def transactions
        respond_with @object.transactions
      end

      def invoice_items
        respond_with @object.invoice_items
      end

      def items
        respond_with @object.items
      end

      def customer
        respond_with @object.customer
      end

      def merchant
        respond_with @object.merchant
      end
    end
  end
end
