class PackagesController < InheritedResources::Base
  
  # GET /packages
  def index
    @categories = Packages.all
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /packages/:id
  def show
    @city = Packages.find_by_id params[:id]

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
end
