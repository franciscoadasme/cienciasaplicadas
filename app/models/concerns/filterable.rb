module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filterable_by(options)
      @filterable_config = options
    end

    def during_date(date_or_params)
      return all if date_or_params.blank?

      date = case
        when date_or_params.is_a?(Hash)
          date_or_params.symbolize_keys!
          year = date_or_params[:year].to_i
          month = (date_or_params[:month] || 1).to_i
          day = (date_or_params[:day] || 1).to_i
          Date.new year, month, day
        else date_or_params
      end
      time_unit = case
        when date_or_params.is_a?(Hash)
          [ :day, :month, :year ].detect { |unit| date_or_params.has_key? unit }
        else :day
      end

      from_date = date.send "beginning_of_#{time_unit}"
      to_date = date.send "end_of_#{time_unit}"

      filterable_field = filterable_config[:date].to_sym
      where filterable_field => from_date..to_date
    end

    private
      def filterable_config
        @filterable_config ||= defaults
      end

      def defaults
        { date: :created_at }
      end
  end
end