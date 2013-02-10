ActiveAdmin.register RouteInfo do
  menu parent: "POIs", label: "Info de Rutas"
  
  index do 
    column :poi do |info|
      link_to info.poi.title, "/admin/route_infos/#{info.id}"
    end
    column :difficulty
    column :length do |info|
      "#{ "%.0f" % info.length }m"
    end
    
    column :bounds do |info|
      "Lat:#{"%.3f" % info.n_bound}, #{"%.3f" % info.s_bound}, Lon:#{"%.3f" % info.e_bound}, #{"%.3f" % info.w_bound}"
    end
    column :elevation do |info|
      "#{"%.0f" % info.min_elevation}m - #{"%.0f" % info.max_elevation}m"
    end
    default_actions
  end
  
  show do
    attributes_table do
      row :id
      row :poi
      row :difficulty
      row :is_circular
      row :length do |info|
        "#{ "%.2f" % info.length }m"
      end
      row :elevation do |info|
        "#{"%.2f" % info.min_elevation}m - #{"%.2f" % info.max_elevation}m"
      end
      row :bounds do |info|
        "Lat:#{"%.5f" % info.n_bound}, #{"%.5f" % info.s_bound}, Lon:#{"%.5f" % info.e_bound}, #{"%.5f" % info.w_bound}"
      end
      row :max_up_slope
      row :max_down_slope
      row :accumulated_up_slope
      row :accumulated_down_slope
    end
    
    attributes_table do
      row :profile do |info|
        html = "<div id=\"route-graph\" width=\"650\" height=\"170\"></div>"
        html += javascript_include_tag "raphael-min"
        html += javascript_include_tag "g.raphael-min"
        html += javascript_include_tag "g.line-min"
        html += "<script>
          var route_points = #{ info.poi.route_points.to_json.html_safe };
          window.onload = function () {
            if (route_points && route_points.length > 0) {
              var r = Raphael(\"route-graph\", 800, 280), x = [], y = [];
              for (var i in route_points) {
                x[i] = parseInt(i); 
                y[i] = parseFloat(route_points[i].elevation);
              }
              r.linechart(20, 0, 760, 280, x, [y], { shade: true, axis: \"0 0 0 1\" });
            }
          };
          </script>"
        html.html_safe
      end
    end
  end
end
