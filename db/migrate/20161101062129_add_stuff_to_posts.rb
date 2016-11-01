class AddStuffToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :summary, :text
    add_column :posts, :published, :boolean, default: false
    add_column :posts, :slug, :string, uniq: true
  end
end
