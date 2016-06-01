module ActiveRecordExtension
  extend ActiveSupport::Concern

  module ClassMethods
    def custom_find(key, val)
      if val.to_i != 0
        find_by(key => val.to_i)
      else
        t = arel_table
        where(t[key].matches("#{val}%")).first
      end
    end

    def custom_where(key, val)
      if val.to_i != 0
        where(key => val.to_i)
      else
        t = arel_table
        where(t[key].matches("#{val}%"))
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecordExtension)
