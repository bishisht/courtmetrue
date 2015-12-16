class IsAdminToProfilePhotos < ActiveRecord::Migration
  def change
        add_column :profile_photos, :is_admin, :boolean
  end
end
