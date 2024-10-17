class AddUsernameToUsers < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:users, :username)
      add_column :users, :username, :string, null: false, default: ""
    end
  end
end