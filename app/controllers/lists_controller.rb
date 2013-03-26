class ListsController < InheritedResources::Base
  
  # POST /list
  # POST /list.json
  def create
    @list = List.new(params[:list])
    respond_to do |format|
      if @list.save
        format.html
        format.json { render json: @list, status: :created, location: @photo }
      else
        format.html
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end
end
