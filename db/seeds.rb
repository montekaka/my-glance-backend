# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.first
profile = user.profiles.create({
  name: "Josh Chen", 
  short_description: "Front-end Developer",
  avatarSrc:"https://avatars.githubusercontent.com/u/1149779?v=4",
  slug: "montekaka",
  font_family: "DM Sans",
  primary_color: '#131C45', # card background color
  secondary_color: "#3CD5ED", # icon background color
  info_color: "#FFFFFF", # text color,
  warning_color: "#182354", # link background color
  danger_color: "#1B275A", # card in card color
  success_color: "#04A3D9", # profile card link button color
  dark_color: '#0E163B', # main background color
  light_color: "#6E7598" # title color or #FFFFFF80
})

