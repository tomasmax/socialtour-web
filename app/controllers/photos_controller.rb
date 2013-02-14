class PhotosController < InheritedResources::Base
  before_filter :authenticate_admin!, except: [:create, :index]
  
  # GET /photos.json
  def index
    @photos = Photo.all

    respond_to do |format|
      format.html
      format.json { render json: @photos }
    end
  end

  # GET /photos/1.json
  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.json { render json: @photo }
    end
  end

  # GET /photos/new.json
  def new
    @photo = Photo.new

    respond_to do |format|
      format.json { render json: @photo }
    end
  end

  # POST /photos
  # POST /photos.json
  def create
    params[:photo][:user_id] = session[:current_user_id]
    @photo = Photo.new(params[:photo])

    respond_to do |format|
      if @photo.save
        format.html { redirect_to poi_url(@photo.poi) }
        format.json { render json: @photo, status: :created, location: @photo }
      else
        format.html { redirect_to poi_url(@photo.poi) }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
