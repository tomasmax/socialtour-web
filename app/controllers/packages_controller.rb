class PackagesController < InheritedResources::Base
  
  # GET /packages
  def index
    @packages = Package.all
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /packages/:id
  def show
    @package = Package.find_by_id params[:id]
    @pois = @package.pois
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
end
