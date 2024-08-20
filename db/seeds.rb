# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Geolocation.find_or_create_by!(ip_address: '1.1.1.1') do |geo|
  geo.country = "Australia"
  geo.region = "Victoria"
  geo.city = "Balwyn North"
  geo.lat = -0.37703602e2
  geo.lon = 0.145180634e3
end

Geolocation.find_or_create_by!(ip_address: '1.1.1.2') do |geo|
  geo.country = "Australia"
  geo.region = "Victoria"
  geo.city = "Balwyn North"
  geo.lat = -0.37703602e2
  geo.lon = 0.145180634e3
end

Geolocation.find_or_create_by!(ip_address: '11.1.1.2') do |geo|
  geo.country = "United States"
  geo.region = "West Virginia"
  geo.city = "Clarksburg"
  geo.lat = 0.39299271e2
  geo.lon = -0.80380623e2
end

Geolocation.find_or_create_by!(ip_address: '11.11.1.2') do |geo|
  geo.country = "United States"
  geo.region = "Virginia"
  geo.city = "Ashburn"
  geo.lat = 0.39043701e2
  geo.lon = -0.77474197e2
end

Geolocation.find_or_create_by!(ip_address: '2607:f8b0:400a:806::2004') do |geo|
  geo.country = "United States"
  geo.region = "Washington"
  geo.city = "Seattle"
  geo.lat = 0.47642109e2
  geo.lon = -0.122406792e3
end

u1 = User.find_or_create_by!(email: "test@test.com") do |user|
  user.password = "password"
end

u1.api_keys.create!(token: "test_token")

User.find_or_create_by!(email: "test2@test.com") do |user|
  user.password = "password"
end