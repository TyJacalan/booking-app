class ServiceDetailsController < ApplicationController
  before_action :authorize_service, only: %i[set show previous]
  before_action :set_service, only: [:show]
  before_action :set_categories, only: [:show]
  before_action :retrieve_previous, only: %i[previous show]

  def set
    begin
      case session[:form]
      when 'title'
        title = params[:service]&.fetch(:title, '')
        description = params[:service]&.fetch(:description, '')

        if title.blank? || description.blank?
          flash[:alert] = 'Title and description cannot be empty'
          redirect_back(fallback_location: detail_services_path) and return
        end

        session[:title] = title
        session[:description] = description
      when 'price'
        price = params[:service]&.fetch(:price, '')

        if price.blank?
          flash[:alert] = 'Price cannot be empty'
          redirect_back(fallback_location: detail_services_path) and return
        end

        session[:price] = price
      end
    rescue ActionController::ParameterMissing => e
      flash[:alert] = "Invalid form parameters: #{e.message}"
      redirect_back(fallback_location: detail_services_path) and return
    end

    puts "set service: #{session[:title]}"
    puts "set service: #{session[:description]}"
    puts "set service: #{session[:price]}"
    puts "set service: #{session[:form]}"

    redirect_to detail_services_path
  end

  def show
    case session[:form]
    when 'categories'
      if session[:selected_categories].blank?
        flash.now[:alert] = 'Choose at least one category'
        render layout: 'service', template: 'services/categories' and return
      end
      session[:form] = 'title' unless @previous
    when 'title'
      session[:form] = 'price' if session[:title].present? && session[:description].present? && !@previous
    when 'price'
      session[:form] = 'preview' if session[:price].present? && !@previous
    end

    render_next_form
  end

  def previous
    case session[:form]
    when 'categories'
      redirect_to root_path and return
    when 'title'
      session[:form] = 'categories'
    when 'price'
      session[:form] = 'title'
    when 'preview'
      session[:form] = 'price'
    end

    session[:previous] = true
    redirect_to detail_services_path
  end

  private

  def set_service
    puts "session id: #{session[:service_id]}"
    @service = session[:service_id].present? ? Service.find(session[:service_id]) : Service.new
    @service.assign_attributes(
      id: session[:service_id],
      title: session[:title],
      price: session[:price],
      description: session[:description],
      categories: retrieve_categories
    )
    puts "service: #{@service.id}"
    puts "service: #{@service.title}"
    puts "service: #{@service.description}"
    puts "service: #{@service.price}"
    puts "service: #{@service.categories}"
  end

  def retrieve_categories
    category_ids = session[:selected_categories]&.map { |category| category['id'] }
    Category.where(id: category_ids)
  end

  def authorize_service
    authorize Service, :new?
  end

  def set_categories
    @categories = Category.all
  end

  def retrieve_previous
    @previous = session.delete(:previous) || false
  end

  def render_next_form
    if session[:form] == 'preview'
      puts "preview service: #{@service.id}"
      puts "service: #{@service.title}"
      puts "service: #{@service.description}"
      puts "service: #{@service.price}"
      puts "service: #{@service.categories}"
      render 'services/preview'
    else
      render layout: 'service', template: "services/#{session[:form]}"
    end
  end
end
