# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create admin users

AdminUser.create(:email => 'tomas.madariaga@urbegi.com', :password => 'admin1234', :password_confirmation => 'admin1234')
AdminUser.create(:email => 'admin@urbegi.com', :password => 'admin1234', :password_confirmation => 'admin1234')

User.create(name: "Minube", :email => "minube@minube.com", :password => 'minube1234', :password_confirmation => 'minube1234')
User.create(name: "Foursquare", :email => "foursquare@foursquare.com", :password => 'foursquare1234', :password_confirmation => 'foursquare1234')

TypeLeisure.create(name: "Ocio solo")
TypeLeisure.create(name: "Ocio con pareja")
TypeLeisure.create(name: "Ocio familiar")
TypeLeisure.create(name: "Ocio con amigos")
TypeLeisure.create(name: "Otros")

TypeTime.create(name: "Mañana")
TypeTime.create(name: "Tarde")
TypeTime.create(name: "Noche")
TypeTime.create(name: "Todo el día")
TypeTime.create(name: "Fin de semana")

TypeVehicle.create(name: "Bicicleta")
TypeVehicle.create(name: "Paseo")
TypeVehicle.create(name: "Correr")
TypeVehicle.create(name: "Coche")
TypeVehicle.create(name: "Moto")

#Load countries minube
countries_url = "http://api.minube.com/locations/countries.json?api_key=c9fd01a957af1f2afb8b3a31f83257c3"
resp = Net::HTTP.get_response URI.parse(countries_url)
result = JSON.parse resp.body
countries = result["response"]["countries"]

countries.each do |c|
   puts "- Country #{c['id']} #{c['name']}"
   country = Country.new c
   country.id = c["id"]
   country.name = c["name"]
   country.pois_count = c["pois_count"]
   country.full_count = c["full_count"]
   country.restaurant_count = c["restaurant_count"]
   country.blog_count = c["blog_count"]
   country.hotel_count = c["hotel_count"]
   country.latitude = c["latitude"]
   country.longitude = c["longitude"]
   country.save
end

# Load supercategories and categories from minube
supercategories_url = "http://api.minube.com/places/supercategories.json?api_key=c9fd01a957af1f2afb8b3a31f83257c3"
resp = Net::HTTP.get_response URI.parse(supercategories_url)
result = JSON.parse resp.body
supercategories = result["response"]["supercategories"]

supercategories.each do |sc|
  puts "- Supercategory #{sc['id']} #{sc['name']}"
  supercategory = Supercategory.new sc
  supercategory.id = sc['id'];
  supercategory.save

  categories_url = "http://api.minube.com/places/categories.json?api_key=c9fd01a957af1f2afb8b3a31f83257c3&supercategory=#{supercategory.id}"
  cat_json = JSON.parse Net::HTTP.get_response(URI.parse(categories_url)).body
  categories = cat_json["response"]["categories"]

  categories.each do |c|
    puts "  Category #{c['id']} #{c['name']}"
    c.delete 'supercategory'
    category = supercategory.categories.new c
    category.id = c['id']
    category.save
  end
  
end

#Load categories foursquare
clientFoursquare = Foursquare2::Client.new(client_id: "IN2OMEKAQP0JAZUB4G2YE5GS11AA3F2TRCCWQ5PVXCEG55PG", client_secret: "CHUBYYCIGCD5H54IB43UQOE4C3PU4FKAPI4CGW0VNQD21SYE", :api_version => '20130215', :locale=>'es')
supCategories = clientFoursquare.venue_categories
supCategories.each do |sc|
  puts "- Super Category FourSquare #{sc.id} #{sc.name}"
  supercategory = Supercategory.new sc #sin mirar las de minube
  supercategory.foursquare_id = sc.id
  supercategory.foursquare_icon = sc.icon.prefix.chop + sc.icon.suffix #chop to cut the last character
  supercategory.icon = open(supercategory.foursquare_icon)
  supercategory.name = sc.pluralName
  sc.save
  sc.categories.each do |c|
    puts "  Category FourSquare #{c.id} #{c.name}"    
    cat = Category.find_by_name(c.pluralName)
    if cat
      cat.foursquare_id = c.id
      cat.foursquare_icon = c.icon.prefix.chop + c.icon.suffix
      cat.name = c.pluralName
    else
      category = Category.new c
      category.foursquare_id = c.id
      category.foursquare_icon = c.icon.prefix.chop + c.icon.suffix
      category.icon = open(category.foursquare_icon)
      category.name = c.pluralName
      category.save
    end
  end
end
