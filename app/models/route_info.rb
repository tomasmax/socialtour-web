class RouteInfo < ActiveRecord::Base
  attr_accessible :accumulated_down_slope, :accumulated_up_slope, :difficulty, :e_bound, :is_circular, :lenght, :max_down_slope, :max_elevation, :min_elevation, :n_bound, :poi, :s_bound, :w_bound
  
  belongs_to :poi
  
  before_save :generate_route_info
  
  R_METERS = 6371 * 1000
  RAD_PER_DEG = 0.017453293
  
  def haversine_distance(lat1, lon1, lat2, lon2)  
    
    dlon = lon2 - lon1  
    dlat = lat2 - lat1  
     
    dlon_rad = dlon * RAD_PER_DEG  
    dlat_rad = dlat * RAD_PER_DEG  
     
    lat1_rad = lat1 * RAD_PER_DEG  
    lon1_rad = lon1 * RAD_PER_DEG  
     
    lat2_rad = lat2 * RAD_PER_DEG  
    lon2_rad = lon2 * RAD_PER_DEG  
     
    # puts "dlon: #{dlon}, dlon_rad: #{dlon_rad}, dlat: #{dlat}, dlat_rad: #{dlat_rad}"  
     
    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2  
    c = 2 * Math.asin( Math.sqrt(a))  
     
    R_METERS * c     # delta in meters  
  end  
  
  def generate_route_info
    n_bound = 180
    s_bound = 0
    e_bound = -180
    w_bound = 180
    length = 0.0
    max_elevation = 0.0
    min_elevation = 9999
    max_up_slope = 0.0
    max_down_slope = 0.0
    accomulated_up_slope = 0.0
    accomulated_down_slope = 0.0
    
    route_points = self.poi.route_points
    
    (0...(route_points.count - 1)).each do |i|
      p0 = route_points[i]
      p1 = route_points[i + 1]
      d = haversine_distance(p0.latitude, p0.longitude, p1.latitude, p1.longitude)
      
      n_bound = [n_bound, p0.latitude, p1.latitude].min
      s_bound = [s_bound, p0.latitude, p1.latitude].max
      e_bound = [e_bound, p0.longitude, p1.longitude].max
      w_bound = [w_bound, p0.longitude, p1.longitude].min
      
      length += d
      max_elevation = [max_elevation, p0.elevation, p1.elevation].max
      min_elevation = [min_elevation, p0.elevation, p1.elevation].min
      
      if p1.elevation > p0.elevation
        max_up_slope = [max_up_slope, (p1.elevation - p0.elevation) / d].max
        accomulated_up_slope += p1.elevation - p0.elevation
      else
        max_down_slope = [max_down_slope, (p0.elevation - p1.elevation) / d].max
        accomulated_down_slope += p0.elevation - p1.elevation
      end
    end
    
    first = route_points.first
    last = route_points.last
    #check if is circular
    self.is_circular = 35 > haversine_distance(first.latitude, first.longitude, last.latitude, last.longitude)
    
    self.n_bound = n_bound
    self.s_bound = s_bound
    self.e_bound = e_bound
    self.w_bound = w_bound
    self.length = length
    self.max_elevation = max_elevation
    self.min_elevation = min_elevation
    self.max_up_slope = max_up_slope
    self.max_down_slope = max_down_slope
    self.accomulated_up_slope = accomulated_up_slope
    self.accomulated_down_slope = accomulated_down_slope
    
  end
end
