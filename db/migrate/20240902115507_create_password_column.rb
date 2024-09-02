class CreatePasswordColumn < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :password_digest, :string
    remove_column :users, :password, :string
  end
end
