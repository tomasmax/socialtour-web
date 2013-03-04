class CountriesController < InheritedResources::Base
  
   # GET /cities
  def index
    @countries = Country.order 'name'
    respond_to do |format|
      format.html # index.html.erb
      format.json {render json: @countries}
    end
  end
  
end
