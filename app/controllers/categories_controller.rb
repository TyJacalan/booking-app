class CategoriesController < ApplicationController
  def index
    if params[:ids]
      @categories = Category.where(id: params[:ids].split(','))
      render json: @categories.to_json(only: %I[id title])
    else
      @categories = Category.all
    end
    authorize Category
  end
end
