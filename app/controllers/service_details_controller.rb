class ServiceDetailsController < ApplicationController
  before_action :authorize_service, only: %i[set show]
  before_action :set_service, only: [:show]
  before_action :set_categories, only: [:show]

  def set
    case session[:form]
    when 'title'
      session[:title] = params[:service]&.fetch(:title, '')
      session[:description] = params[:service]&.fetch(:description, '')
    when 'price'
      session[:price] = params[:service]&.fetch(:price, '')
    end

    redirect_to detail_services_path
  end

  def show
    case session[:form]
    when 'categories'
      if session[:selected_categories].blank?
        flash.now[:alert] = 'Choose at least one category'
        render layout: 'new_service', template: 'services/categories' and return
      end
      session[:form] = 'title'
    when 'title'
      if session[:title].blank?
        flash.now[:alert] = 'Provide title'
        render layout: 'new_service', template: 'services/title' and return
      elsif session[:description].blank?
        flash.now[:alert] = 'Provide description'
        render layout: 'new_service', template: 'services/title' and return
      end
      session[:form] = 'price'
    when 'price'
      if session[:price].blank?
        flash.now[:alert] = 'Set your price'
        render layout: 'new_service', template: 'services/price' and return
      end
      render 'services/preview' and return
    end

    render layout: 'new_service', template: "services/#{session[:form]}"
  end

  private

  def set_service
    category_ids = session[:selected_categories].map { |category_hash| category_hash['id'] }
    categories = Category.where(id: category_ids)

    @service = Service.new
    @service = Service.new(
      title: session[:title],
      price: session[:price],
      description: session[:description],
      categories:
    )
  end

  def authorize_service
    authorize Service, :new?
  end

  def set_categories
    @categories = Category.all
  end
end
