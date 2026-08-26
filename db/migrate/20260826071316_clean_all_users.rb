class CleanAllUsers < ActiveRecord::Migration[8.0]
  def up
    User.destroy_all
  end

  def down
  end
end