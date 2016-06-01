module Api
  module V1
    class CustomersController < ApiController
      respond_to :json

      def index
        respond_with Customer.all
      end

      def show
        respond_with Customer.find(params[:id])
      end

      def random
        respond_with Customer.limit(1).order("RANDOM()").first
      end

      def find
        key = params.keys.first
        respond_with Customer.custom_find(key, params[key])
      end

      def find_all
        key = params.keys.first
        respond_with Customer.custom_where(key, params[key])
      end
    end
  end
end
