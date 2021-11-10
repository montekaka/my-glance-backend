class Profile < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, :use => :slugged
  validates :slug, uniqueness: true
  validates :slug, presence: true
  validate :slug_validates

  belongs_to :user
  has_many :social_networks
  has_many :tech_skills

  def slug_candidates
    slug = SecureRandom.uuid[0..4]
    reserved = ['edit','new','session']
    while (Profile.where(slug: slug).exists? || reserved.include?(slug))
      slug = SecureRandom.uuid[0..4]
    end

    return slug
  end

  def sync_social_networks items
    # behavior:
    # we will remove all social networks if we can't find from the itmes arr
    # we will update social network with a positive id in the items *
    # we will create social network with a negative id in the items **
    # * if unable to perform the update, then add an err_message
    # ** if unable to perform the create, then add an err_message
    delete_items = []
    social_networks_dict = {}

    items.each_with_index do |item, idx|
      id = item["id"]
      social_networks_dict[id] = idx      
    end

    social_networks = self.social_networks    
    social_networks.each do |sn|
      id = sn[:id]
      if social_networks_dict[id] == nil
        delete_items.push(id)
      end
    end

    # delete      
    if delete_items.count > 0
      to_delete_items = self.social_networks.where(id: delete_items)
      to_delete_items.destroy_all
      social_networks = self.social_networks # refresh the social_networks arr, without deleted items    
    end
    # create or update
    res_items = []
    items.each do |item|
      if item["id"] < 0
        # create
        created_item = self.social_networks.new({name: item["name"], icon_name: item["icon_name"], sort_order: item["sort_order"], url: item["url"]})
        unless created_item.save
          # puts created_item.errors
          item["errors"] = created_item.errors.messages
        end
        res_items.push(item)
      else
        # update
        social_network = self.social_networks.find_by_id(item["id"])
        if social_network
          social_network.update({name: item["name"], icon_name: item["icon_name"], sort_order: item["sort_order"], url: item["url"]})
        end
        res_items.push(social_network)
      end
    end
    
    res_items.sort {|a, b| a["sort_order"] <=> b["sort_order"]}
  end


  def sync_tech_skills items
    # behavior:
    # we will remove all social networks if we can't find from the itmes arr
    # we will update social network with a positive id in the items *
    # we will create social network with a negative id in the items **
    # * if unable to perform the update, then add an err_message
    # ** if unable to perform the create, then add an err_message
    delete_items = []
    tech_skills_dict = {}

    items.each_with_index do |item, idx|
      id = item["id"]
      tech_skills_dict[id] = idx      
    end
    
    tech_skills = self.tech_skills    
    tech_skills.each do |sn|
      id = sn[:id]
      if tech_skills_dict[id] == nil
        delete_items.push(id)
      end
    end
    
    # delete      
    if delete_items.count > 0
      to_delete_items = self.tech_skills.where(id: delete_items)
      to_delete_items.destroy_all
      tech_skills = self.tech_skills # refresh the tech_skills arr, without deleted items    
    end
    # create or update
    res_items = []
    items.each do |item|
      if item["id"] < 0
        # create
        created_item = self.tech_skills.new({name: item["name"], icon_name: item["icon_name"], sort_order: item["sort_order"], url: item["url"]})
        if created_item.save
          res_items.push(created_item)
        else
          # puts created_item.errors
          item["errors"] = created_item.errors.messages
          res_items.push(item)
        end
        
      else
        # update
        tech_skill = self.tech_skills.find_by_id(item["id"])
        if tech_skill
          tech_skill.update({name: item["name"], icon_name: item["icon_name"], sort_order: item["sort_order"], url: item["url"]})
          res_items.push(tech_skill)
        end        
      end
    end

    res_items.sort {|a, b| a["sort_order"] <=> b["sort_order"]}
    # if res_items.length < 2      
    #   res_items
    # else
    #   res_items.sort {|a, b| a["sort_order"] <=> b["sort_order"]}
    # end
  end  
  
  private
  def slug_validates
    # do not allow
    reserved = ['edit','new','session']
    if slug.match /\/|\\|\,|\.|\@|\?|\#|\&|\%|\*|\!|\`/
      errors.add(:slug, "cannot use special characters")
    elsif reserved.include?(slug)
      errors.add(:slug, "cannot use following words: edit, new, session")
    elsif slug.length < 4
      errors.add(:slug, "cannot be less than 5 characters")
    end
  end
end