class RemoveUselessColumn < ActiveRecord::Migration[7.2]
  def change
    remove_column :records, :publication, :string
  end
end
