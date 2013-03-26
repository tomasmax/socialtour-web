# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'nokogiri'
require 'uri'
require 'net/http'

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

# Create admin users
AdminUser.create(:email => 'tomas.madariaga@urbegi.com', :password => 'admin1234', :password_confirmation => 'admin1234')
AdminUser.create(:email => 'admin@urbegi.com', :password => 'admin1234', :password_confirmation => 'admin1234')

User.create(name: "Minube", :email => "minube@minube.com", :password => 'minube1234', :password_confirmation => 'minube1234')
User.create(name: "Foursquare", :email => "foursquare@foursquare.com", :password => 'foursquare1234', :password_confirmation => 'foursquare1234')

#cargar desde ficheros
f = File.read('files/countries.json')
countries = JSON.parse f
countries.each do |c|
   country = Country.new
   country.minube_id = c["id"]
   country.name = c["name"]
   country.pois_count = c["pois_count"]
   country.full_count = c["full_count"]
   country.restaurant_count = c["restaurant_count"]
   country.blog_count = c["blog_count"]
   country.hotel_count = c["hotel_count"]
   country.latitude = c["latitude"]
   country.longitude = c["longitude"]
   country.save
   puts "- Country #{c['id']} #{c['name']}"
end

f = File.read('files/supercategories_minube.json')
supercategories = JSON.parse f
supercategories.each do |sc|
  supercategory = SupercategoryMinube.new(name: sc['name'], id: sc['id'])
  if supercategory.save
    puts "- Supercategory #{sc['id']} #{sc['name']}"
  end
end

f = File.read('files/categories_minube.json')
categories = JSON.parse f
categories.each do |c|
  category = CategoryMinube.new(name: c['name'], supercategory_minube_id: c['supercategory_id'], group: c['group'], id: c['id'])
  puts "  Category #{c['id']} #{c['name']}" if category.save
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

f2 = SupercategoryFoursquare.find_by_id(5)
mi = SupercategoryMinube.find_by_id(1)
name = "Interes turístico & Recreation"
sc = Supercategory.new
sc.id = 1
sc.name = name
sc.name_en = f2.name_en if f2
sc.foursquare_id = f2.foursquare_id if f2
sc.minube_id = mi.id if mi
sc.foursquare_icon = f2.foursquare_icon if f2
sc.icon = open(sc.foursquare_icon) if sc.foursquare_icon 
sc.group = "see"
sc.save
SupercategoryRelation.create(supercategory_foursquare_id: f2.id, supercategory_minube_id: mi.id, supercategory_id: sc.id)

#Cultura | minube: 2-cultura | 2-Facultad y universidad
sc = Supercategory.new
f2 = SupercategoryFoursquare.find_by_id(1)
f22 = SupercategoryFoursquare.find_by_id(2)
mi = SupercategoryMinube.find_by_id(2)
name = "Cultura"
sc.id = Supercategory.last.id+1
sc.name = name
sc.name_en = f2.name_en if f2
sc.foursquare_id = f2.foursquare_id if f2
sc.minube_id = mi.id if mi
sc.foursquare_icon = f2.foursquare_icon if f2
sc.icon = open(sc.foursquare_icon) if sc.foursquare_icon 
sc.group = "see"
sc.save
SupercategoryRelation.create(supercategory_foursquare_id: f2.id, supercategory_minube_id: mi.id, supercategory_id: sc.id)

#Ocio y Entretenimiento | minube: 3 - Ocio | foursquare: 1-Arte y entretenimiento
#Recordar de minube categorias 36 - Interes Gastronomico, 34 - Bares de Tapas, 29 -Restaurantes -> a la categoria de Comida
sc = Supercategory.new
f2 = SupercategoryFoursquare.find_by_id(1)
mi = SupercategoryMinube.find_by_id(3)
name = "Ocio y entreteniemiento"
sc.id = Supercategory.last.id+1
sc.name = name
sc.name_en = f2.name_en if f2
sc.foursquare_id = f2.foursquare_id if f2
sc.minube_id = mi.id if mi
sc.foursquare_icon = f2.foursquare_icon if f2
sc.icon = open(sc.foursquare_icon) if sc.foursquare_icon 
sc.group = "do"
sc.save
SupercategoryRelation.create(supercategory_foursquare_id: f2.id, supercategory_minube_id: mi.id, supercategory_id: sc.id)

#Comida, from forusquare 3
#Recordar de minube categorias 36 - Interes Gastronomico, 34 - Bares de Tapas, 29 -Restaurantes de la categoria 3-Ocio de minube van en esta
sc = Supercategory.new
f2 = SupercategoryFoursquare.find_by_id(3)
name = "Comida"
sc.id = Supercategory.last.id+1
sc.name = name
sc.name_en = f2.name_en if f2
sc.foursquare_id = f2.foursquare_id if f2
sc.foursquare_icon = f2.foursquare_icon if f2
sc.icon = open(sc.foursquare_icon) if sc.foursquare_icon 
sc.group = "eat"
sc.save
SupercategoryRelation.create(supercategory_foursquare_id: f2.id, supercategory_minube_id: nil, supercategory_id: sc.id)

#Local Nocturno, from foursquare 4
#41  Zonas de Copas    Ocio  do    de minube
#40  Bares de Copas    Ocio  do    de minube
#39  Discotecas  pasarlas a esta

sc = Supercategory.new
f2 = SupercategoryFoursquare.find_by_id(4)
sc.name = "Bares y Pubs"
sc.id = Supercategory.last.id+1
sc.name_en = f2.name_en if f2
sc.foursquare_id = f2.foursquare_id if f2
sc.foursquare_icon = f2.foursquare_icon if f2
sc.icon = open(sc.foursquare_icon) if sc.foursquare_icon 
sc.group = "do"
sc.save
SupercategoryRelation.create(supercategory_foursquare_id: f2.id, supercategory_minube_id: nil, supercategory_id: sc.id)

#Actividades Deportivas, from minube 4
sc = Supercategory.new
mi = SupercategoryMinube.find_by_id(4)
sc.name = mi.name
sc.name_en = "Sport activities"
sc.id = Supercategory.last.id+1
sc.minube_id = mi.id if mi
sc.group = "do"
sc.save
SupercategoryRelation.create(supercategory_foursquare_id: nil, supercategory_minube_id: mi.id, supercategory_id: sc.id)

#Eventos, from minube 5
sc = Supercategory.new
mi = SupercategoryMinube.find_by_id(5)
sc.name = mi.name
sc.name_en = "Events"
sc.id = Supercategory.last.id+1
sc.minube_id = mi.id if mi
sc.group = "do"
sc.save
SupercategoryRelation.create(supercategory_foursquare_id: nil, supercategory_minube_id: mi.id, supercategory_id: sc.id)

#Alojamiento y Transporte | minube : 6-Alojamiento, 7-Transporte | foursquare: 9 -Viajes y Transporte
sc = Supercategory.new
f2 = SupercategoryFoursquare.find_by_id(9)
mi = SupercategoryMinube.find_by_id(6)
mi2 = SupercategoryMinube.find_by_id(7)
sc.name = "Alojamiento y Transporte"
sc.id = Supercategory.last.id+1
sc.name_en = f2.name_en if f2
sc.foursquare_id = f2.foursquare_id if f2
sc.minube_id = mi.id if mi
sc.foursquare_icon = f2.foursquare_icon if f2
sc.icon = open(sc.foursquare_icon) if sc.foursquare_icon
sc.group = "travel"
sc.save
SupercategoryRelation.create(supercategory_foursquare_id: f2.id, supercategory_minube_id: mi.id, supercategory_id: sc.id)
SupercategoryRelation.create(supercategory_foursquare_id: f2.id, supercategory_minube_id: mi.id, supercategory_id: sc.id)

#Tiendas y Servicios | minube: 6-Administraciones y Servicios | foursquare: 8-Tiendas y servicios
sc = Supercategory.new
f2 = SupercategoryFoursquare.find_by_id(8)
mi = SupercategoryMinube.find_by_id(6)
sc.name = "Tiendas, Administraciones y Servicios"
sc.id = Supercategory.last.id+1
sc.name_en = f2.name_en if f2
sc.foursquare_id = f2.foursquare_id if f2
sc.minube_id = mi.id if mi
sc.foursquare_icon = f2.foursquare_icon if f2
sc.icon = open(sc.foursquare_icon) if sc.foursquare_icon
sc.group = "do"
sc.save
SupercategoryRelation.create(supercategory_foursquare_id: f2.id, supercategory_minube_id: mi.id, supercategory_id: sc.id)

#Profesionales y otros, from foursquare 6
sc = Supercategory.new
f2 = SupercategoryFoursquare.find_by_id(6)
sc.name = f2.name
sc.id = Supercategory.last.id+1
sc.name_en = f2.name_en if f2
sc.foursquare_id = f2.foursquare_id if f2
sc.foursquare_icon = f2.foursquare_icon if f2
sc.icon = open(sc.foursquare_icon) if sc.foursquare_icon
sc.group = "do"
sc.save
SupercategoryRelation.create(supercategory_foursquare_id: f2.id, supercategory_minube_id: nil, supercategory_id: sc.id)

puts "-My Supercategories created"

#Categories
scs = Supercategory.all
scs.each do |supercategory|
  puts "Supercategory: "+supercategory.name
  if supercategory.minube_id
    supercategory.supercategory_minubes.each do |scm|
      categories_minube = scm.category_minubes
      categories_minube.each do |c|
        category = Category.new
        #Comida, from forusquare 3
        #Recordar de minube categorias 36 - Interes Gastronomico, 34 - Bares de Tapas, 29 -Restaurantes de la categoria 3-Ocio de minube van en esta
        #41  Zonas de Copas    Ocio  do    de minube
        #40  Bares de Copas    Ocio  do    de minube
        #39  Discotecas  pasarlas a la supercategory 5
        if supercategory.id == 3
          if c.id == 36 || c.id == 34 || c.id == 29
            category.supercategory_id = 4 #asignar supercategoria de comida
          elsif c.id == 41 || c.id == 40 || c.id == 39
            category.supercategory_id = 5 #asignar supercategoria de bares
          end
        else
          category.supercategory_id = supercategory.id
        end
        category.name = c.name
        category.group = c.group
        category.minube_id = c.id
        category.foursquare_id = nil
        if category.save
          puts "- Created category from (minube): "+ category.name  
        end
      end
    end
  end
  
  if supercategory.foursquare_id
    supercategory.supercategory_foursquares.each do |scf|
      categories_foursquare = scf.category_foursquares
      categories_foursquare.each do |c|   
        cat_ex = Category.where("lower(name) LIKE :name", name: "#{c.name}%".downcase)
        if !cat_ex.first.nil? #actualizar la existente
          cat_ex.first.update_attributes(foursquare_id: c.foursquare_id, foursquare_icon: c.foursquare_icon)
          CategoryRelation.create(category_foursquare_id: c.id, category_minube_id: cat_ex.first.minube_id, category_id: cat_ex.first.id)
          puts "- Updated category: "+ cat_ex.first.name
        else #crear
          category = supercategory.categories.new
          category.name = c.pluralName
          category.name_en = c.name_en
          category.foursquare_id = c.foursquare_id
          category.foursquare_icon = c.foursquare_icon
          category.group = supercategory.group
          category.minube_id = nil
          if !c.foursquare_icon.blank? && category.name != "Puentes"
            
            begin 
             if category.icon = open(c.foursquare_icon, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE) #production VERIFY_PEER
              puts "New icon #{c.foursquare_icon} for category "+ category.name
             end 
             rescue => e
               case e
               when OpenURI::HTTPError
                 # do something
                 puts "HTTP Error getting #{category.name} photo"
               when SocketError
                 # do something else
               else
                 raise e
               end
              rescue SystemCallError => e
               if e === Errno::ECONNRESET
                # do something else
               else
                raise e
               end
             end
          end
          if category.save
            puts "- Created category from (foursquare): "+ category.name
          end
          
          if c.subcategory_foursquares
            c.subcategory_foursquares.each do |subc|
              subcategory = category.subcategories.new
              subcategory.name = subc.pluralName
              subcategory.name_en = subc.name_en
              subcategory.foursquare_id = subc.foursquare_id
              subcategory.foursquare_icon = subc.foursquare_icon
              if subcategory.save
                puts "- Created subcategory from (foursquare): "+ subcategory.name
              end
            end
          end
        end
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
Category.create(name:"Cuenta cuento", group: "do", supercategory_id: sp.id)
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
Category.create(name:"Pastoral", group: "do", supercategory_id: sp.id)
Category.create(name:"Payasos", group: "do", supercategory_id: sp.id)
Category.create(name:"Monólogos", group: "do", supercategory_id: sp.id)
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

TypeTime.create(name: 'Mañana')
TypeTime.create(name: "Tarde")
TypeTime.create(name: "Noche")
TypeTime.create(name: "Todo el día")
TypeTime.create(name: "Fin de semana")
puts "TypeTimes saved"
