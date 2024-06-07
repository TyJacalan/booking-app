class CategoriesController < ApplicationController
  def select
    @category = Category.find(params[:id])
    session[:selected_categories] ||= []
    category_in_session = session[:selected_categories].find { |c| c['id'] == @category.id }

    puts "in session? #{category_in_session}"
    if category_in_session
      # Remove category if it's already in the session
      session[:selected_categories].delete_if { |c| c['id'] == @category.id }
    else
      # Add category to the session if it's not present
      session[:selected_categories] << @category
    end

    authorize Service, :select_category?
    redirect_back(fallback_location: root_path)
  end
end
