# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'supercategory'
require 'category'

# Create admin users
AdminUser.create(:email => 'tomas.madariaga@urbegi.com', :password => 'admin1234', :password_confirmation => 'admin1234')
AdminUser.create(:email => 'admin@urbegi.com', :password => 'admin1234', :password_confirmation => 'admin1234')

User.create(name: "Minube", :email => "minube@minube.com", :password => 'minube1234', :password_confirmation => 'minube1234')
User.create(name: "Foursquare", :email => "foursquare@foursquare.com", :password => 'foursquare1234', :password_confirmation => 'foursquare1234')

=begin
#Load countries minube
countries_url = "http://api.minube.com/locations/countries.json?api_key=c9fd01a957af1f2afb8b3a31f83257c3"
resp = Net::HTTP.get_response URI.parse(countries_url)
result = JSON.parse resp.body
#f = File.read('files/countries.json')
#result = JSON.parse f
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
  #f = File.read('files/categories_minube.json')
  #categories = JSON.parse f
  
  categories.each do |c|
    puts "  Category #{c['id']} #{c['name']}"
    c.delete 'supercategory'
    category = supercategory.categories.new c
    category.id = c['id']
    category.save
  end
  
end
=end

#cargar desde ficheros
f = File.read('files/countries.json')
countries = JSON.parse f
countries.each do |c|
  country = Country.new c
  country.save
end

f = File.read('files/supercategories_minube.json')
supercategories = JSON.parse f
supercategories.each do |sc|
  supercategory = SupercategoryMinube.new sc
  supercategory.save
end

f = File.read('files/categories_minube.json')
categories = JSON.parse f
categories.each do |c|
  rcategory = CategoryMinube.new c
  category.save
end

#Load categories foursquare
clientFoursquare = Foursquare2::Client.new(client_id: "IN2OMEKAQP0JAZUB4G2YE5GS11AA3F2TRCCWQ5PVXCEG55PG", client_secret: "CHUBYYCIGCD5H54IB43UQOE4C3PU4FKAPI4CGW0VNQD21SYE", :api_version => '20130215', :locale=>'es')
clientFoursquareEn = Foursquare2::Client.new(client_id: "IN2OMEKAQP0JAZUB4G2YE5GS11AA3F2TRCCWQ5PVXCEG55PG", client_secret: "CHUBYYCIGCD5H54IB43UQOE4C3PU4FKAPI4CGW0VNQD21SYE", :api_version => '20130215', :locale=>'en')
supCategories = clientFoursquare.venue_categories
supCategoriesEn = clientFoursquareEn.venue_categories
supCategories.each_with_index do |sc, i|
  puts "- Super Category FourSquare #{sc.id} #{sc.name}"
  supercategory = SupercategoryFoursquare.new #sin mirar las de minube
  supercategory.foursquare_id = sc.id
  supercategory.foursquare_icon = sc.icon.prefix.chop + sc.icon.suffix #chop to cut the last character
  #supercategory.icon = open(supercategory.foursquare_icon)
  supercategory.name = sc.name
  supercategory.name_en = supCategoriesEn[i].name
  supercategory.pluralName = sc.pluralName
  supercategory.shortName = sc.shortName
  supercategory.save
  sc.categories.each_with_index do |c, j|
    puts "  Category FourSquare #{c.id} #{c.name}"    
      category = supercategory.category_foursquares.new
      category.foursquare_id = c.id
      category.foursquare_icon = c.icon.prefix.chop + c.icon.suffix
      #category.icon = open(category.foursquare_icon)
      category.name = c.name
      category.name_en = supCategoriesEn[i].categories[j].name
      category.pluralName = c.pluralName
      category.shortName = c.shortName
      category.save
      if c.categories.size > 0
        c.categories.each_with_index do |suc, k|
          puts "  SubCategory FourSquare #{suc.id} #{suc.name}"
          subcategory = category.subcategory_foursquares.new
          subcategory.foursquare_id = suc.id
          subcategory.foursquare_icon = suc.icon.prefix.chop + suc.icon.suffix
          #subcategory.icon = open(subcategory.foursquare_icon)
          subcategory.name = suc.name
          subcategory.name_en = supCategoriesEn[i].categories[j].categories[k].name
          subcategory.pluralName = suc.pluralName
          subcategory.shortName = suc.shortName
          subcategory.save
        end 
      end
  end
end

#SuperCategories
#Interes turístico & recreation | minube: 1-interes_turistico | foursquare: 5-Outdoors&recreation
sc = Supercategory.new
f2 = SupercategoryFoursquare.find_by_id(5)
mi = SupercategoryMinube.find_by_id(1)
name = "Interes turístico & Recreation"
sc.populate(f2,mi,name)
sc.save
CategoryRelation.create(foursquare_id: f2.foursquare_id, minube_id: mi.id, my_category_id: sc.id)

#Cultura | minube: 2-cultura | 2-Facultad y universidad
sc = Supercategory.new
f2 = SupercategoryFoursquare.find_by_id(1)
f22 = SupercategoryFoursquare.find_by_id(2)
mi = SupercategoryMinube.find_by_id(2)
name = "Cultura"
sc.populate(f2,mi,name)
sc.save
CategoryRelation.create(foursquare_id: f2.foursquare_id, minube_id: mi.id, my_category_id: sc.id)

#Ocio y Entretenimiento | minube: 3 - Ocio | foursquare: 1-Arte y entretenimiento
#Recordar de minube categorias 36 - Interes Gastronomico, 34 - Bares de Tapas, 29 -Restaurantes -> a la categoria de Comida
sc = Supercategory.new
f2 = SupercategoryFoursquare.find_by_id(1)
mi = SupercategoryMinube.find_by_id(3)
name = "Ocio y entreteniemiento"
sc.populate(f2,mi,name)
sc.save
CategoryRelation.create(foursquare_id: f2.foursquare_id, minube_id: mi.id, my_category_id: sc.id)

#Comida, from forusquare 3
#Recordar de minube categorias 36 - Interes Gastronomico, 34 - Bares de Tapas, 29 -Restaurantes de la categoria 3-Ocio de minube van en esta
sc = Supercategory.new
f2 = SupercategoryFoursquare.find_by_id(3)
name = "Comida"
sc.populate(f2,nil,name)
sc.save
CategoryRelation.create(foursquare_id: f2.foursquare_id, my_category_id: sc.id)

#Local Nocturno, from foursquare 4
#41  Zonas de Copas    Ocio  do    de minube
#40  Bares de Copas    Ocio  do    de minube
#39  Discotecas  pasarlas a esta

sc = Supercategory.new
f2 = SupercategoryFoursquare.find_by_id(4)
name = "Local Nocturno"
sc.populate(f2,nil,name)
sc.save
CategoryRelation.create(foursquare_id: f2.foursquare_id, my_category_id: sc.id)

#Actividades Deportivas, from minube 4
sc = Supercategory.new
mi = SupercategoryMinube.find_by_id(4)
name = mi.name
sc.populate(nil,mi,name)
sc.save
CategoryRelation.create(minube_id: mi.id, my_category_id: sc.id)

#Eventos, from minube 5
sc = Supercategory.new
mi = SupercategoryMinube.find_by_id(5)
name = mi.name
sc.populate(nil,mi,name)
sc.save
CategoryRelation.create(minube_id: mi.id, my_category_id: sc.id)

#Alojamiento y Transporte | minube : 6-Alojamiento, 7-Transporte | foursquare: 9 -Viajes y Transporte
sc = Supercategory.new
f2 = SupercategoryFoursquare.find_by_id(9)
mi = SupercategoryMinube.find_by_id(6)
mi2 = SupercategoryMinube.find_by_id(7)
name = "Alojamiento y Transporte"
sc.populate(f2,mi,name)
sc.save
CategoryRelation.create(foursquare_id: f2.foursquare_id, minube_id: mi.id, my_category_id: sc.id)
CategoryRelation.create(foursquare_id: f2.foursquare_id, minube_id: mi2.id, my_category_id: sc.id)

#Tiendas y Servicios | minube: 6-Administraciones y Servicios | foursquare: 8-Tiendas y servicios
sc = Supercategory.new
f2 = SupercategoryFoursquare.find_by_id(8)
mi = SupercategoryMinube.find_by_id(6)
name = "Tiendas, Administraciones y Servicios"
sc.populate(f2,mi,name)
sc.save
CategoryRelation.create(foursquare_id: f2.foursquare_id, minube_id: mi.id, my_category_id: sc.id)

#Profesionales y otros, from foursquare 6
sc = Supercategory.new
f2 = SupercategoryFoursquare.find_by_id(6)
name = f2.name
sc.populate(f2,nil,name)
sc.save
CategoryRelation.create(foursquare_id: f2.foursquare_id, my_category_id: sc.id)

puts "My Supercategories created"

#Categories
scs = Supercategory.all
scs.each do |supercategory|
  if supercategory.foursquare_id
    categories_foursquare = CategoryFoursquare.where(supercategory_id: supercategory.id)
    categories_foursquare.each do |c|
      category = Category.new
      category.load_foursquare_data(c)
      if category.save
        puts "- Created category: "+ category.name
      end
    end
  end
  if supercategory.minube_id
    categories_minube = CategoryMinube.where(supercategory_id: supercategory.id)
    categories_minube.each do |c|
      cat_ex = Category.where("name LIKE :name", name: "#{c.name}%")
      if cat_ex #actualizar la existente
        cat_ex.minube_id = c.id
      else #crear
        category = Category.new 
        
      end
    end
  end
end

#Create event categories from kulturtik
sp = Supercategory.find_by_name("Eventos")
Category.create(name:"Teatro", group: "do", supercategory_id: sp.id)
Category.create(name:"Exposición", group: "do", supercategory_id: sp.id)
Category.create(name:"Danza", group: "do", supercategory_id: sp.id)
Category.create(name:"Opera", group: "do", supercategory_id: sp.id)
Category.create(name:"Presentación", group: "do", supercategory_id: sp.id)
Category.create(name:"Bertsolaritza", group: "do", supercategory_id: sp.id)
Category.create(name:"Conferencia", group: "do", supercategory_id: sp.id)
Category.create(name:"Recital", group: "do", supercategory_id: sp.id)
Category.create(name:"Cuenta cuentos", group: "do", supercategory_id: sp.id)
Category.create(name:"Conferencia", group: "do", supercategory_id: sp.id)
Category.create(name:"Feria de artesanía", group: "do", supercategory_id: sp.id)
Category.create(name:"Feria del libro", group: "do", supercategory_id: sp.id)
Category.create(name:"Títeres", group: "do", supercategory_id: sp.id)
Category.create(name:"Proyección audiovisual", group: "do", supercategory_id: sp.id)
Category.create(name:"Jornadas", group: "do", supercategory_id: sp.id)
Category.create(name:"Curso-taller", group: "do", supercategory_id: sp.id)
Category.create(name:"Consurso", group: "do", supercategory_id: sp.id)
Category.create(name:"Festival", group: "do", supercategory_id: sp.id)
Category.create(name:"Actividad infantil", group: "do", supercategory_id: sp.id)
Category.create(name:"Magia", group: "do", supercategory_id: sp.id)
Category.create(name:"Circo", group: "do", supercategory_id: sp.id)
Category.create(name:"Conferencia", group: "do", supercategory_id: sp.id)
Category.create(name:"Pastoral", group: "do", supercategory_id: sp.id)
Category.create(name:"Payasos", group: "do", supercategory_id: sp.id)
Category.create(name:"Monologos", group: "do", supercategory_id: sp.id)
Category.create(name:"Humor", group: "do", supercategory_id: sp.id)
puts "Kulturtik categories saved"

#Create some cities
City.create(name: "Bilbao")
City.create(name: "Gernika")
City.create(name: "Bakio")
City.create(name: "Algorta")
City.create(name: "Getxo")
City.create(name: "Sopelana")
City.create(name: "Bermeo")
City.create(name: "Lekeitio")
City.create(name: "San Sebastian")
puts "Some cities saved"

#Create package types
TypeLeisure.create(name: "Ocio solo")
TypeLeisure.create(name: "Ocio con pareja")
TypeLeisure.create(name: "Ocio familiar")
TypeLeisure.create(name: "Ocio con amigos")
TypeLeisure.create(name: "Otros")
puts "TypeTimes saved"

TypeVehicle.create(name: "Bicicleta")
TypeVehicle.create(name: "Paseo")
TypeVehicle.create(name: "Correr")
TypeVehicle.create(name: "Coche")
TypeVehicle.create(name: "Moto")
puts "TypeTimes saved"

TypeTime.create(name: 'Maniana')
TypeTime.create(name: "Tarde")
TypeTime.create(name: "Noche")
TypeTime.create(name: "Todo el dia")
TypeTime.create(name: "Fin de semana")
puts "TypeTimes saved"
