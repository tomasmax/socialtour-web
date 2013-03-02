class RetrievalController < ApplicationController
  
  
  # GET /retrieval
  # GET /retrieval.json
  def retrieval
    params[:order] = params[:order] ? params[:order].to_i : 0
    
    @pois = Poi #falta pasarle la ciudad
    
    if params[:name] && !params[:name].empty?
      search = "%" + params[:name].sub(" ", "%") + "%"
      @pois = @pois.where('name like ? OR name_eu like ?', search, search)
    end
    
    if params[:category] && params[:category] != "null"  && !params[:category].empty?
      @pois = Poi.where(category_id: params[:category])
    end

    if params[:order] == 0
      @pois = @pois.order('created_at desc')
    else
      @pois = @pois.order('rating desc')
    end
    
    @pois = @pois.page(params[:page]).per(10) 

    respond_to do |format|
      format.html # retrieval.html.erb
      format.js # retrieval.js.erb
    end
  end
  
end
