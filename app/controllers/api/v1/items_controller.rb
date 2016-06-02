module Api
  module V1
    class ItemsController < SuperController
      respond_to :json

      def model
        controller_name.classify.constantize
      end

      def invoice_items
        respond_with @object.invoice_items
      end

      def merchant
        respond_with @object.merchant
      end
    end
  end
end
