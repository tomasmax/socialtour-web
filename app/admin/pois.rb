ActiveAdmin.register Poi do
  menu priority: 1, label: "POIs"

  action_item do
    link_to "Importar varios desde GPX", "/admin/pois/import_gpx"
  end

  collection_action :import_gpx
  
  collection_action :submit_gpx, method: :post do
    begin
      gpx = GPX::GPXFile.new gpx_file: params[:gpx_file].tempfile.path
      
      pois_count = 0
      if gpx.tracks
        gpx.tracks.each do |track|
          track_poi = Poi.new name: track.name, description: track.name, user_id: session[:current_user_id], 
            latitude: track.points.first.lat, longitude: track.points.first.lon, rating: 0, ratings_count: 0
          track_poi.save!
          
          track.points.each do |route_point|
            track_poi.route_points.new(latitude: route_point.lat, longitude: route_point.lon, elevation: route_point.elevation).save!
          end
          pois_count += 1
        end
      end
      
      if gpx.routes
        gpx.routes.each do |track|
          track_poi = Poi.new name: track.name, description: track.name, user_id: session[:current_user_id], 
            latitude: track.points.first.lat, longitude: track.points.first.lon, rating: 0, ratings_count: 0
          track_poi.save!
          
          track.points.each do |route_point|
            track_poi.route_points.new(latitude: route_point.lat, longitude: route_point.lon, elevation: route_point.elevation).save!
          end
          pois_count += 1
        end
      end
      
      redirect_to '/admin/pois', notice: "GPX importado: #{pois_count} POI(s) creados"
    rescue
      redirect_to '/admin/pois/import_gpx', alert: "Fichero invalido"
    end
  end
  
  show do
    attributes_table do
      row :id
      row :slug
      row :name
      row :name_eu
      row :description
      row :description_eu
      row :rating do |p|
        "#{p.rating} (#{p.ratings_count})"
      end
      row :user
      row :minube_id
      row :category
      row :supercategory
      row :coordinates do |p|
        "#{p.latitude}, #{p.longitude}"
      end
      
      row :route_info do |p|
        link_to "Info de ruta", "/admin/route_infos/#{p.route_info.id}" if p.route_info
      end
      row :route_points do |p|
        p.route_points.count if p.route_points
      end
      row :address
      row :telephone
      row :timetable
      row :website
      row :minube_url
      row :created_at
      row :updated_at
      
      row :photos do |poi|
        html = ""
        poi.photos.each do |p|
          html += link_to image_tag(p.image.url(:thumb)), "/admin/photos/#{p.id}", style: "margin-left: 10px;"
        end
        html.html_safe
      end
    end
    
    attributes_table do
      row :map do |p|
        html = '<div id="poi-map-canvas" style="width: 800px; height: 450px; margin: 22px 0 30px -5px; display: block; clear: both;"></div>'
        html += "<script>var poi = #{ p.to_json.html_safe }; poi.route_points = #{ p.route_points.to_json.html_safe };</script>"
        html += javascript_include_tag "http://maps.googleapis.com/maps/api/js?sensor=false"
        html += javascript_include_tag "pois-show"
        html.html_safe
      end
    end
  end

  form html: { enctype: "multipart/form-data" } do |f|
    f.inputs "POI" do
      f.input :user
      f.input :city
      f.input :supercategory
      f.input :category
      f.input :name
      f.input :name_eu
      f.input :slug
      f.input :description
      f.input :description_eu
      f.input :latitude
      f.input :longitude
      f.input :rating
      f.input :address
      f.input :telephone
      f.input :timetable
      f.input :website
      f.input :minube_url
    end
    
    f.inputs "Fichero GPX" do
      f.input :gpx_file, as: :file
    end
    f.buttons
  end

  index do 
    column :name
    column :description do |poi|
      truncate poi.description, length: 20
    end  
    column :rating do |poi|
      "#{poi.rating} (#{poi.ratings_count})"
    end
    column :coordinates do |poi|
      "#{poi.latitude}, #{poi.longitude}"
    end
    column :slug
    column :category
    column :city
    column :created_at
    
    default_actions
  end  
end
