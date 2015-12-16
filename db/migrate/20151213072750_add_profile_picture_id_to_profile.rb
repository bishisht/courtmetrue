class AddProfilePictureIdToProfile < ActiveRecord::Migration
  def change
    add_column :profiles  , :profile_picture_id, :int
  end
end
