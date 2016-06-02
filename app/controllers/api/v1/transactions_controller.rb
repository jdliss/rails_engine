module Api
  module V1
    class TransactionsController < SuperController
      respond_to :json

      def model
        controller_name.classify.constantize
      end

      def invoice
        respond_with @object.invoice
      end
    end
  end
end
