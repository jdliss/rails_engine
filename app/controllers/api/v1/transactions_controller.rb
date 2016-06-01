module Api
  module V1
    class TransactionsController < ApiController
      respond_to :json

      def index
        respond_with Transaction.all
      end

      def show
        respond_with Transaction.find(params[:id])
      end

      def random
        respond_with Transaction.limit(1).order("RANDOM()").first
      end

      def find
        key = params.keys.first
        respond_with Transaction.custom_find(key, params[key])
      end

      def find_all
        key = params.keys.first
        respond_with Transaction.custom_where(key, params[key])
      end
    end
  end
end
