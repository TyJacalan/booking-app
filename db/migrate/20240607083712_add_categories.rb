class AddCategories < ActiveRecord::Migration[7.1]
  def up
    categories = [
      { title: 'Choreographer', icon: 'fa-solid fa-hands' },
      { title: 'Entertainer', icon: 'fa-solid fa-masks-theater' },
      { title: 'Event Host', icon: 'fa-solid fa-microphone' },
      { title: 'Event Planner', icon: 'fa-solid fa-wine-glass' },
      { title: 'Makeup Artist', icon: 'fa-solid fa-wand-magic-sparkles' },
      { title: 'Musician', icon: 'fa-solid fa-guitar' },
      { title: 'Photographer', icon: 'fa-solid fa-camera' },
      { title: 'Stylist', icon: 'fa-solid fa-person-dress-burst' },
      { title: 'Videographer', icon: 'fa-solid fa-video' }
    ]

    categories.each do |category|
      Category.create_or_find_by!(category)
    end
  end

  def down
    Category.delete_all
  end
end