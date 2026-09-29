# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Crear usuario administrador
admin = User.find_or_initialize_by(email: 'admin@adminadmon.com')
admin.password = 'Admin1234*'
admin.password_confirmation = 'Admin1234*'
admin.admin = true if admin.respond_to?(:admin)
admin.save!
puts "Usuario administrador creado con �xito: admin@ejemplo.com"
