class ErrorsController < ApplicationController
  skip_after_action :verify_authorized

  layout 'error'

  def not_found
    @status_code = '404'
    @status_header = 'Page not found'
    @status_body = "Sorry, we couldn't find the page you're looking for."
    render status: :not_found
  end

  def forbidden
    @status_code = '403'
    @status_header = 'Access not granted.'
    render status: :forbidden
  end

  def unprocessable
    @status_code = '422'
    @status_header = 'Unprocessable entity.'
    @status_body = "We're sorry, we are unable to process your request due to validation errors."
    render status: :unprocessable_entity
  end

  def internal_server_error
    @status_code = '500'
    @status_header = 'Something went wrong.'
    @status_body = "It's not you, it's me :("
    render status: :internal_server_error
  end
end
