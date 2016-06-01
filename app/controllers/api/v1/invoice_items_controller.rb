module Api
  module V1
    class InvoiceItemsController < ApiController
      respond_to :json

      def index
        respond_with InvoiceItem.all
      end

      def show
        respond_with InvoiceItem.find(params[:id])
      end

      def random
        respond_with InvoiceItem.limit(1).order("RANDOM()").first
      end

      def find
        key = params.keys.first
        respond_with InvoiceItem.custom_find(key, params[key])
      end

      def find_all
        key = params.keys.first
        respond_with InvoiceItem.custom_where(key, params[key])
      end
    end
  end
end
