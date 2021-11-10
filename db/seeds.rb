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

profile.social_networks.create([
  {icon_name: 'twitter', name: 'Twitter', url: "https://twitter.com/settings/profile", sort_order: 1},
  {icon_name: 'github', name: 'Github', url: "https://github.com/montekaka", sort_order: 2},  
  {icon_name: 'dev', name: 'Dev.to', url: "https://dev.to/montekaka", sort_order: 3},  
])

profile.tech_skills.create([
  {icon_name: 'react-js', name: 'React.js', sort_order: 1},
  {icon_name: 'my-sql', name: 'MySQL', sort_order: 2},
  {icon_name: 'nginx', name: 'Nginx', sort_order: 3},
])

profile.widgets.create([
  {
    is_dynamic_content: false, 
    type: 'tweet',
    link_type: "general",
    section_name: "banner",
    name: "Pinned Tweet", 
    icon_name: "twitter",
    post_title: "JustCast",
    user_name: "thejustcast",    
    avatar_url: "https://pbs.twimg.com/profile_images/1241559383475019776/YuSkJug9_400x400.jpg",
    post_description: "Introducing Podcast Ninja: a free and open source fully customizable widget player that supports @PodcastindexOrg chapters namespace.",
    url: "https://twitter.com/thejustcast/status/1427107126640398341"
  }, 
  {
    is_dynamic_content: true, 
    type: 'github_calendar',
    link_type: "github",
    section_name: "body",
    name: "Github", 
    icon_name: "github",
    user_name: "montekaka",    
    avatar_url: "https://pbs.twimg.com/profile_images/1241559383475019776/YuSkJug9_400x400.jpg",
    url: "https://twitter.com/thejustcast/status/1427107126640398341",
    sort_order: 1
  },
  {
    is_dynamic_content: true, 
    type: 'list',
    section_name: "body",
    name: "Medium Posts", 
    icon_name: "medium",
    user_name: "@justcastapp", 
    link_type: 'medium',   
    url: "https://medium.com/feed/@justcastapp",
    sort_order: 2
  },     
  {
    is_dynamic_content: true, 
    type: "list",
    section_name: "body",
    name: "Dev.to Posts", 
    icon_name: "dev",
    user_name: "montekaka", 
    link_type: 'dev',   
    show_thumbnail: true,
    url: "https://dev.to/feed/montekaka",
    sort_order: 3
  },       
])