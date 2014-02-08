module Filterable
  extend ActiveSupport::Concern

  def scope_with_date(relation, field = :created_at)
    date = Date.new params[:year].to_i, (params[:month] || 1).to_i
    from_date = date.beginning_of_month
    to_date = date.end_of_month
    relation.where field.to_sym => from_date..to_date
  end
end