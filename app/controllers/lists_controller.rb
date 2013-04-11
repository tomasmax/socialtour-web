class ListsController < InheritedResources::Base
  
  # GET /photos.json
  def index
    @lists = List.all

    respond_to do |format|
      format.html
      format.json { render json: @lists }
    end
  end

  # GET /photos/1.json
  def show
    @list = Photo.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @list }
    end
  end

  # GET /photos/new.json
  def new
    @list = Photo.new

    respond_to do |format|
      format.json { render json: @list }
    end
  end
  
  # POST /list
  # POST /list.json
  def create
    @list = List.new(params[:list])
    respond_to do |format|
      if @list.save
        format.html
        format.json { render json: @list, status: :created }
      else
        format.html
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end
end
