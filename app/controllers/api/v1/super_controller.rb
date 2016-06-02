module Api
  module V1
    class SuperController < ApiController
      before_action :find_object, except: [:index, :show, :random, :find_all]

      def index
        respond_with model.all
      end

      def show
        key, val = clean_params(params)
        respond_with model.find_by(key => val)
      end

      def random
        respond_with model.limit(1).order("RANDOM()").first
      end

      def find_all
        key, val = clean_params(params)
        respond_with model.where(key => val)
      end

      private

      def clean_params(params)
        ["format", "controller", "action"].each do |key|
          params.delete(key)
        end
        key = params.keys.first
        [key, params[key]]
      end

      def find_object
        @object = model.find(params[:id])
      end
    end
  end
end
