class LocationsController < ApplicationController
  def index
    q = params[:q]
    @cities = PhilLocator::City.all.select { |city| city.name.downcase.include?(q.downcase) }
    authorize User
  end
end
