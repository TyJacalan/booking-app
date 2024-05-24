class CategoriesController < ApplicationController
  def select
    @category = params[:category]
    session[:selected_categories] ||= []
    session[:selected_categories] << @category unless session[:selected_categories].include?(@category)
    session[:form] = 'categories'

    authorize Service, :select_category?
  end
end
