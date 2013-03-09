class EventsController < InheritedResources::Base
  
  # GET /events.json
  def index
    if params[:all] == true
      @events = Event.all?
    end
    
    if params[:from] && params[:to]
      @events = Event.where('starts_at < ? AND ends_at > ?', params[:to], params[:from])
    end

    respond_to do |format|
      format.json { render json: @events }
    end
  end

  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.json { render json: @event }
    end
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.json { render json: @event, status: :created, location: @event }
      else
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
