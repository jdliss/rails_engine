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

      def action_missing(name)
        begin
          self.send name
        rescue
          if @object.respond_to?(name)
            respond_with @object.send(name)
          else
            raise AbstractController::ActionNotFound
          end
        end
      end

      private

      def model
        controller_name.classify.constantize
      end

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
