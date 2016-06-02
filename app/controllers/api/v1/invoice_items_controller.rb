module Api
  module V1
    class InvoiceItemsController < SuperController
      respond_to :json

      def model
        controller_name.classify.constantize
      end

      def invoice
        respond_with @object.invoice
      end

      def item
        respond_with @object.item
      end
    end
  end
end
