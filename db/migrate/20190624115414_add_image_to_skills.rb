class AddImageToSkills < ActiveRecord::Migration[5.0]
  def change
    add_column :skills, :image, :string
  end
end
