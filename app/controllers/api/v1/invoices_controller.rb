module Api
  module V1
    class InvoicesController < ApiController
      respond_to :json

      def index
        respond_with Invoice.all
      end

      def show
        respond_with Invoice.find(params[:id])
      end

      def random
        respond_with Invoice.limit(1).order("RANDOM()").first
      end

      def find
        key = params.keys.first
        respond_with Invoice.custom_find(key, params[key])
      end

      def find_all
        key = params.keys.first
        respond_with Invoice.custom_where(key, params[key])
      end
    end
  end
end
