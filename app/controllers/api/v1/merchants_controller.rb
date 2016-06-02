module Api
  module V1
    class MerchantsController < SuperController
      respond_to :json

      def model
        controller_name.classify.constantize
      end

      def items
        respond_with @object.items
      end

      def invoices
        respond_with @object.invoices
      end
    end
  end
end
